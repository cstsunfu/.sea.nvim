-- Browser preview of the avante conversation.
--
-- The sidebar renders markdown inside the terminal; this module extracts the
-- conversation from avante's chat history, keeps it in a real markdown file
-- under the cache dir, and serves it through markdown-preview.nvim, so the
-- answer can be read (and shared) in a browser.
--
-- Rendering keeps working while the answer streams: the avante result buffer is
-- watched with nvim_buf_attach and the preview is refreshed when it has been
-- quiet for a moment.
local M = {}

local state = {
    buf = nil, -- buffer holding the extracted markdown
    previewing = false,
    group = nil, -- augroup for this preview's autocmds
    result_buf = nil, -- avante result buffer we watch
    timer = nil, -- debounce timer for refresh()
    pending_anchor = nil, -- fragment appended when the page opens
    turn_count = 0, -- turns in the last render
    page_open = false, -- whether this buffer's page really opened
}

--- Open a preview URL; used as markdown-preview's browser function so the
--- page can start at the newest turn instead of the top of the document.
---@param url string
function M._open(url)
    local anchor = state.pending_anchor
    state.pending_anchor = nil
    if anchor then
        url = url .. "#" .. anchor
    end
    local opened = pcall(vim.ui.open, url)
    if not opened then
        vim.fn.jobstart({ "open", url }, { detach = true })
    end
end

local function ensure_browser_func()
    if vim.g.__avante_preview_browser_installed then
        return
    end
    -- Called from the node server over RPC (a fast context), so schedule the
    -- work; luaeval's _A is not available inside the deferred closure, hence
    -- the url travels through a Vim global.
    vim.cmd([[function! AvantePreviewOpenBrowser(url) abort
  let g:__avante_preview_last_url = a:url
  call luaeval("vim.schedule(function() require('util.avante_preview')._open(vim.g.__avante_preview_last_url) end)")
endfunction]])
    vim.g.__avante_preview_browser_installed = 1
end

local function notify(msg, level)
    vim.notify("[avante-preview] " .. msg, level or vim.log.levels.INFO)
end

--- Result carried by an attempt_completion tool call, if any.
--- The agent mode stores the final answer there instead of in a text item,
--- which is why a plain text extraction only sees the first turn.
---@param input table|string|nil
---@return string|nil
local function completion_result(input)
    local data = input
    if type(data) == "string" then
        local ok, decoded = pcall(vim.json.decode, data)
        data = ok and decoded or nil
    end
    if type(data) == "table" and type(data.result) == "string" and data.result ~= "" then
        return data.result
    end
    return nil
end

--- Input of a tool call as a table (history stores it decoded, but a JSON
--- string is possible too).
---@param input table|string|nil
---@return table|string|nil
local function tool_input(input)
    if type(input) == "string" then
        local ok, decoded = pcall(vim.json.decode, input)
        return ok and decoded or input
    end
    return input
end

local function first_line(text, limit)
    text = tostring(text or ""):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
    if #text > limit then
        text = text:sub(1, limit - 3) .. "..."
    end
    return text
end

--- Push the headings of an answer one level down so the question headings
--- stay the only entries of the table of contents.
---@param text string
---@param levels integer
---@return string
local function demote_headings(text, levels)
    return (text:gsub("(\n?)(#+)(%s)", function(prefix, hashes, space)
        local depth = #hashes + levels
        if depth > 6 then
            depth = 6
        end
        return prefix .. string.rep("#", depth) .. space
    end))
end

--- Split one assistant message into its answer text and its tool calls.
--- In agentic mode the final answer lives in the attempt_completion input.
---@param message table
---@return string|nil answer
---@return table[] tools
local function assistant_parts(message)
    local content = message.message and message.message.content
    if type(content) == "string" then
        return content ~= "" and content or nil, {}
    end
    if type(content) ~= "table" then
        return nil, {}
    end

    local answers, tools = {}, {}
    for _, item in ipairs(content) do
        if type(item) == "string" then
            table.insert(answers, item)
        elseif type(item) == "table" then
            if item.type == "text" and type(item.content) == "string" then
                table.insert(answers, item.content)
            elseif item.type == "tool_use" then
                if item.name == "attempt_completion" then
                    local result = completion_result(item.input)
                    if result then
                        table.insert(answers, result)
                    end
                else
                    table.insert(tools, { name = item.name or "tool", input = tool_input(item.input) })
                end
            end
        end
    end
    local answer = #answers > 0 and table.concat(answers, "\n") or nil
    return answer, tools
end

--- One <details> block; the blank line after the tag is what makes the
--- markdown-it renderer parse the body as markdown instead of raw text.
local function details(summary, body)
    if body == nil or body == "" then
        return nil
    end
    return ("<details>\n<summary>%s</summary>\n\n%s\n\n</details>"):format(summary, body)
end

--- Collapsed list of the tool calls of one turn.
---@param tools table[]
---@return string|nil
local function render_tools(tools)
    if #tools == 0 then
        return nil
    end
    local blocks = {}
    for _, tool in ipairs(tools) do
        local input = tool.input
        local detail = ""
        if type(input) == "table" then
            detail = input.command or input.path or input.pattern or input.query or ""
            if detail == "" then
                detail = vim.json.encode(input)
            end
        elseif type(input) == "string" then
            detail = input
        end
        local label = first_line(detail, 100)
        local body
        if tool.name == "bash" and type(input) == "table" and type(input.command) == "string" then
            body = ("```bash\n%s\n```"):format(input.command)
        else
            local json = type(input) == "table" and vim.json.encode(input) or tostring(input or "")
            body = ("```json\n%s\n```"):format(json:sub(1, 4000))
        end
        table.insert(blocks, ("<details>\n<summary><code>%s</code> %s</summary>\n\n%s\n\n</details>"):format(
            tool.name,
            label,
            body
        ))
    end
    return ("<details>\n<summary>Tool calls (%d)</summary>\n\n%s\n\n</details>"):format(
        #tools,
        table.concat(blocks, "\n\n")
    )
end

--- The conversation as a markdown document.
---
--- Turns in chronological order; every older answer (and every list of tool
--- calls) is collapsed inside a <details> block, the newest one is expanded.
--- [[toc]] is expanded by markdown-preview into a table of contents, and each
--- turn carries an <a id="turn-N"> anchor so the page can be opened at the
--- newest turn.
---@param sidebar avante.Sidebar
---@return string markdown
---@return integer[] anchors line number (1-based) of each turn anchor
function M.markdown(sidebar)
    local history = sidebar.chat_history or {}
    local title = history.title or "Avante"

    local turns = {}
    local current
    for _, message in ipairs(history.messages or {}) do
        if message.visible ~= false and not message.just_for_display and message.message then
            local role = message.message.role
            if role == "user" then
                local content = message.message.content
                local question = type(content) == "string" and content or nil
                if question and question ~= "" then
                    current = { question = question, answers = {}, tools = {} }
                    table.insert(turns, current)
                end
            elseif role == "assistant" and current then
                local answer, tools = assistant_parts(message)
                if answer then
                    table.insert(current.answers, answer)
                end
                vim.list_extend(current.tools, tools)
            end
        end
    end

    local parts = { ("# Avante — %s"):format(title), "[[toc]]" }
    local anchors = {}

    for index, turn in ipairs(turns) do
        local latest = index == #turns
        local answer = #turn.answers > 0 and demote_headings(table.concat(turn.answers, "\n\n"), 2)
            or "_(no answer)_"
        local tools = render_tools(turn.tools)

        table.insert(parts, ("## %d. %s"):format(index, first_line(turn.question, 120)))
        -- Anchor after the heading so the fragment lands on the question even
        -- when the answer below is collapsed.
        table.insert(parts, ("<a id=\"turn-%d\"></a>"):format(index))
        anchors[index] = #parts
        if latest then
            table.insert(parts, answer)
        else
            table.insert(parts, details("Answer (expand)", answer) or answer)
        end
        if tools then
            table.insert(parts, tools)
        end
    end

    return table.concat(parts, "\n\n"), anchors
end

local function cache_path()
    local dir = vim.fn.stdpath("cache") .. "/avante-preview"
    vim.fn.mkdir(dir, "p")
    return dir .. "/answer.md"
end

local function sidebar_result_buf(sidebar)
    local result = sidebar.containers and sidebar.containers.result
    return result and result.bufnr or nil
end

--- Rewrite the preview buffer (and the file on disk) from the chat history.
---@param sidebar avante.Sidebar
local function refresh(sidebar)
    if not (state.buf and vim.api.nvim_buf_is_valid(state.buf)) then
        return
    end
    local markdown, anchors = M.markdown(sidebar)
    local lines = vim.split(markdown, "\n", { plain = true })

    vim.bo[state.buf].modifiable = true
    vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
    vim.bo[state.buf].modified = false
    vim.bo[state.buf].modifiable = false
    state.turn_count = #anchors

    pcall(vim.fn.writefile, lines, cache_path())
    if state.previewing then
        vim.api.nvim_buf_call(state.buf, function()
            pcall(vim.fn["mkdp#rpc#preview_refresh"])
        end)
    end
end

local function schedule_refresh()
    if not (state.buf and vim.api.nvim_buf_is_valid(state.buf)) then
        return
    end
    if not state.timer then
        state.timer = vim.uv.new_timer()
    end
    state.timer:stop()
    state.timer:start(600, 0, vim.schedule_wrap(function()
        local ok, sidebar = pcall(function()
            return require("avante").get()
        end)
        if ok and sidebar and sidebar.chat_history then
            refresh(sidebar)
        end
    end))
end

--- Open the browser preview for the current tab's avante conversation.
function M.start()
    local ok, sidebar = pcall(function()
        return require("avante").get()
    end)
    if not ok or not sidebar or not sidebar.chat_history then
        notify("open the avante sidebar first", vim.log.levels.WARN)
        return
    end

    require("lazy").load({ plugins = { "markdown-preview.nvim" } })

    if not (state.buf and vim.api.nvim_buf_is_valid(state.buf)) then
        state.buf = vim.api.nvim_create_buf(false, true)
        pcall(vim.api.nvim_buf_set_name, state.buf, cache_path())
        vim.bo[state.buf].filetype = "markdown"
        vim.bo[state.buf].buflisted = false
        vim.bo[state.buf].swapfile = false
    end
    refresh(sidebar)

    -- markdown-preview resolves bufnr('%') when the node server calls back, so
    -- the preview buffer has to stay current until the page has been opened.
    -- mkdp_auto_close must be 0 during that window or BufHidden kills the page.
    local group = vim.api.nvim_create_augroup("AvantePreview" .. state.buf, { clear = true })
    state.group = group

    local win = vim.api.nvim_get_current_win()
    local prev_buf = vim.api.nvim_get_current_buf()
    pcall(vim.api.nvim_del_augroup_by_name, "MKDP_REFRESH_INIT" .. state.buf)
    vim.api.nvim_win_set_buf(win, state.buf)
    local saved_auto_close = vim.g.mkdp_auto_close
    vim.g.mkdp_auto_close = 0
    -- Ask markdown-preview to open the page at the newest turn, and track
    -- whether it opened at all (closing a page before the node server is
    -- initialized makes it throw and leaves the RPC unanswered).
    ensure_browser_func()
    vim.g.mkdp_browserfunc = "AvantePreviewOpenBrowser"
    state.pending_anchor = "turn-" .. math.max(1, state.turn_count)
    -- Only question headings belong in the generated table of contents.
    local saved_options = vim.g.mkdp_preview_options
    vim.g.mkdp_preview_options = vim.tbl_deep_extend("force", saved_options or {}, {
        toc = { level = { 2, 2 } },
    })
    local previewed, err = pcall(vim.cmd, "MarkdownPreview")
    local page_open = false
    if previewed then
        page_open = vim.wait(8000, function()
            local ok_grp, acs = pcall(vim.api.nvim_get_autocmds, { group = "MKDP_REFRESH_INIT" .. state.buf })
            return ok_grp and #acs > 0
        end, 20)
    end
    state.page_open = page_open
    vim.g.mkdp_auto_close = saved_auto_close
    vim.g.mkdp_preview_options = saved_options
    if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_set_buf(win, prev_buf)
    end
    if not previewed then
        notify("MarkdownPreview failed: " .. tostring(err), vim.log.levels.ERROR)
        return
    end

    state.previewing = true

    -- Follow the answer while it streams.
    local result_buf = sidebar_result_buf(sidebar)
    if result_buf and result_buf ~= state.result_buf and vim.api.nvim_buf_is_valid(result_buf) then
        state.result_buf = result_buf
        vim.api.nvim_buf_attach(result_buf, false, {
            on_lines = function()
                schedule_refresh()
            end,
            on_detach = function()
                state.result_buf = nil
            end,
        })
    end

    notify("previewing the avante conversation in the browser")
end

--- Close the browser preview and drop the extracted buffer.
function M.stop()
    if state.timer then
        state.timer:stop()
    end
    if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
        if state.page_open then
            vim.api.nvim_buf_call(state.buf, function()
                pcall(vim.cmd, "MarkdownPreviewStop")
            end)
        end
        pcall(vim.api.nvim_buf_delete, state.buf, { force = true })
    end
    state.buf = nil
    state.result_buf = nil
    state.previewing = false
    state.page_open = false
    state.pending_anchor = nil
end

function M.toggle()
    if state.previewing then
        M.stop()
        return
    end
    M.start()
end

return M
