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
    pending_anchor = nil, -- fragment to append when the page opens
}

--- Open a preview URL; used as markdown-preview's browser function so the
--- page can be opened at the newest turn instead of the top of the document.
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
    -- Called from the node server over RPC, i.e. in a fast context: schedule
    -- the work and pass the url as an argument (luaeval's _A is not available
    -- inside the deferred closure).
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

--- Text of one history message: plain text items plus the answer the agent
--- delivered through attempt_completion.
---@param message table
---@return string|nil
local function message_text(message)
    local content = message.message and message.message.content
    if type(content) == "string" then
        return content
    end
    if type(content) ~= "table" then
        return nil
    end
    local parts = {}
    for _, item in ipairs(content) do
        if type(item) == "string" then
            table.insert(parts, item)
        elseif type(item) == "table" then
            if item.type == "text" and type(item.content) == "string" then
                table.insert(parts, item.content)
            elseif item.type == "tool_use" and item.name == "attempt_completion" then
                local result = completion_result(item.input)
                if result then
                    table.insert(parts, result)
                end
            end
        end
    end
    if #parts == 0 then
        return nil
    end
    return table.concat(parts, "\n")
end

--- First line of a question, for the table of contents.
---@param text string
---@return string
local function snippet(text)
    local one_line = text:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
    if vim.fn.strchars(one_line) > 60 then
        one_line = vim.fn.strcharpart(one_line, 0, 60) .. "…"
    end
    return one_line
end

--- Split the history into turns: one question plus everything the assistant
--- said before the next question.
---@param sidebar avante.Sidebar
---@return { question: string, answer: string[] }[]
function M.turns(sidebar)
    local history = sidebar.chat_history or {}
    local turns = {}
    for _, message in ipairs(history.messages or {}) do
        if message.visible ~= false and not message.just_for_display and message.message then
            local text = message_text(message)
            if text and text ~= "" then
                if message.message.role == "user" then
                    table.insert(turns, { question = text, answer = {} })
                else
                    local turn = turns[#turns]
                    if not turn then
                        turn = { question = "", answer = {} }
                        table.insert(turns, turn)
                    end
                    table.insert(turn.answer, text)
                end
            end
        end
    end
    return turns
end

--- The conversation as a markdown document, one anchored section per turn.
---@param sidebar avante.Sidebar
---@return string markdown
---@return integer[] anchors line number (1-based) of each turn anchor
function M.markdown(sidebar)
    local history = sidebar.chat_history or {}
    local title = history.title or "Avante"
    local turns = M.turns(sidebar)
    local lines = { ("# Avante — %s"):format(title), "" }

    if #turns > 0 then
        table.insert(lines, "**Turns**")
        table.insert(lines, "")
        for index, turn in ipairs(turns) do
            local label = turn.question ~= "" and snippet(turn.question) or ("answer %d"):format(index)
            table.insert(lines, ("%d. [%s](#turn-%d)"):format(index, label, index))
        end
        table.insert(lines, "")
    end

    local anchors = {}
    for index, turn in ipairs(turns) do
        table.insert(lines, ("<a id=\"turn-%d\"></a>"):format(index))
        anchors[index] = #lines
        if turn.question ~= "" then
            table.insert(lines, "")
            table.insert(lines, "> " .. turn.question:gsub("\n", "\n> "))
        end
        for _, answer in ipairs(turn.answer) do
            table.insert(lines, "")
            vim.list_extend(lines, vim.split(answer, "\n", { plain = true }))
        end
        table.insert(lines, "")
        table.insert(lines, "---")
        table.insert(lines, "")
    end

    return table.concat(lines, "\n"), anchors
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

    pcall(vim.fn.writefile, lines, cache_path())

    -- markdown-preview scrolls the page to the buffer cursor on every refresh,
    -- so point it at the newest turn before asking for the refresh.
    local newest = anchors[#anchors] or 1
    state.latest_anchor = newest
    local win = vim.fn.bufwinid(state.buf)
    if win ~= -1 then
        pcall(vim.api.nvim_win_set_cursor, win, { newest, 0 })
    else
        vim.api.nvim_buf_call(state.buf, function()
            pcall(vim.api.nvim_win_set_cursor, 0, { newest, 0 })
        end)
    end
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

    -- Open the page at the newest turn: markdown-preview appends the fragment
    -- we hand it here, and the document carries one anchor per turn.
    ensure_browser_func()
    vim.g.mkdp_browserfunc = "AvantePreviewOpenBrowser"
    state.pending_anchor = "turn-" .. math.max(1, #M.turns(sidebar))

    -- markdown-preview resolves bufnr('%') when the node server calls back, so
    -- the preview buffer has to stay current until the page has been opened.
    -- mkdp_auto_close must be 0 during that window or BufHidden kills the page.
    local group = vim.api.nvim_create_augroup("AvantePreview" .. state.buf, { clear = true })
    state.group = group

    local win = vim.api.nvim_get_current_win()
    local prev_buf = vim.api.nvim_get_current_buf()
    pcall(vim.api.nvim_del_augroup_by_name, "MKDP_REFRESH_INIT" .. state.buf)
    vim.api.nvim_win_set_buf(win, state.buf)
    -- showing the buffer resets the window cursor; put it back on the newest
    -- turn before the page is opened, the scroll sync reads it from here.
    pcall(vim.api.nvim_win_set_cursor, win, { state.latest_anchor or 1, 0 })
    local saved_auto_close = vim.g.mkdp_auto_close
    vim.g.mkdp_auto_close = 0
    -- On a cold start the node server opens the page itself right after it
    -- initializes; when the server was already running :MarkdownPreview opens
    -- it immediately. Either way the browser function below is what receives
    -- the URL, so the anchor can be appended there.
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
    if page_open and vim.api.nvim_win_is_valid(win) then
        -- the page opened with the first content; refresh once more so it
        -- scrolls to the newest turn before the window goes back
        refresh(sidebar)
    end
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
        -- Closing a page before the node server finished initializing makes it
        -- throw and leaves the RPC unanswered; only stop what really opened.
        if state.page_open then
            vim.api.nvim_buf_call(state.buf, function()
                pcall(vim.cmd, "MarkdownPreviewStop")
            end)
        end
        pcall(vim.api.nvim_buf_delete, state.buf, { force = true })
    end
    state.page_open = false
    state.pending_anchor = nil
    state.buf = nil
    state.result_buf = nil
    state.previewing = false
end

function M.toggle()
    if state.previewing then
        M.stop()
        return
    end
    M.start()
end

return M
