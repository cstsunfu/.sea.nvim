-- Smart Markdown preview bridge for iamcco/markdown-preview.nvim.
--
-- markdown-preview.nvim serves only the current buffer, so browser clicks on
-- relative Markdown links cannot open another Neovim buffer. This module:
--   1. Detects an Obsidian vault by looking for an ancestor `.obsidian`.
--   2. Rewrites local `[label](note.md#heading)` links to a loopback relay in
--      every Markdown file. Inside a vault it also rewrites Obsidian syntax.
--      - `![[img.png]]`          -> `![img.png](/abs/path)` (vault-wide lookup)
--      - `![[img.png|WxH]]`      -> `<img ... width=W height=H>`
--      - `[[note#header|alias]]` -> link to a local click-relay URL
--   3. Runs a tiny loopback HTTP server (vim.uv) that receives clicks on those
--      links, opens the target note in Neovim (jumping to the header), and
--      starts a new markdown-preview tab for it. The HTTP 204 response keeps
--      the originating preview tab untouched.
--   4. Previews a scratch buffer holding the rewritten content, leaving the
--      user's buffer unmodified, and mirrors edits into it for live refresh.

local uv = vim.uv or vim.loop

local M = {}

local IMAGE_EXTS = { "png", "jpg", "jpeg", "gif", "svg", "webp", "bmp" }
local MARKDOWN_EXTS = { md = true, markdown = true, mkd = true, mdown = true, mkdn = true, mdwn = true }
local PORT_RANGE = { 18200, 19599 }

local state = {
    server = nil, -- uv tcp handle
    port = nil,
    vaults = {}, -- vault_root -> { md = {name -> {paths}}, img = {name -> {paths}} }
    previews = {}, -- orig bufnr -> { temp = bufnr, group = augroup id }
    leave_autocmd = false,
}

-- ---------------------------------------------------------------------------
-- small helpers
-- ---------------------------------------------------------------------------

local function url_encode(s)
    return (s:gsub("([^%w%-%_%.%~])", function(c)
        return string.format("%%%02X", string.byte(c))
    end))
end

local function url_decode(s)
    return (s:gsub("+", " "):gsub("%%(%x%x)", function(h)
        return string.char(tonumber(h, 16))
    end))
end

local function escape_html(s)
    return (s:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub('"', "&quot;"))
end

local function notify(msg, level)
    vim.notify("[markdown-preview] " .. msg, level or vim.log.levels.INFO)
end

local function normalize_path(path)
    return vim.fs.normalize(vim.fn.fnamemodify(path, ":p"))
end

local function path_is_within(path, root)
    path = normalize_path(path)
    root = normalize_path(root):gsub("/$", "")
    return path == root or vim.startswith(path, root .. "/")
end

local function is_markdown_file(path)
    local ext = path:match("%.([^./]+)$")
    return ext ~= nil and MARKDOWN_EXTS[ext:lower()] == true
end

-- ---------------------------------------------------------------------------
-- vault discovery + index
-- ---------------------------------------------------------------------------

local function find_vault_root(file)
    if file == "" then
        return nil
    end
    local dir = vim.fn.fnamemodify(file, ":p:h")
    local hit = vim.fs.find(".obsidian", { path = dir, upward = true, type = "directory" })[1]
    return hit and vim.fn.fnamemodify(hit, ":h") or nil
end

local function find_project_root(file)
    local dir = vim.fn.fnamemodify(file, ":p:h")
    local hit = vim.fs.find(".git", { path = dir, upward = true })[1]
    return hit and vim.fn.fnamemodify(hit, ":h") or dir
end

local function is_hidden_path(path, root)
    local relative = path:sub(#normalize_path(root):gsub("/$", "") + 2)
    return relative:match("^%.") ~= nil or relative:find("/%.") ~= nil
end

local function scan_vault(vault)
    local idx = { md = {}, img = {} }
    local md_files = vim.fn.globpath(vault, "**/*.md", true, true)
    local img_files = {}
    for _, ext in ipairs(IMAGE_EXTS) do
        vim.list_extend(img_files, vim.fn.globpath(vault, "**/*." .. ext, true, true))
    end
    for _, f in ipairs(md_files) do
        if not is_hidden_path(f, vault) then
            local key = vim.fn.fnamemodify(f, ":t:r"):lower()
            idx.md[key] = idx.md[key] or {}
            table.insert(idx.md[key], f)
        end
    end
    for _, f in ipairs(img_files) do
        if not is_hidden_path(f, vault) then
            local key = vim.fn.fnamemodify(f, ":t"):lower()
            idx.img[key] = idx.img[key] or {}
            table.insert(idx.img[key], f)
        end
    end
    state.vaults[vault] = idx
    return idx
end

-- Pick the best match among candidates: same directory as the current file
-- first, then prefer /Images/ for assets, then the shallowest path.
local function pick_best(candidates, current_file, prefer_images_dir)
    if #candidates == 1 then
        return candidates[1]
    end
    local current_dir = vim.fn.fnamemodify(current_file, ":p:h")
    local best, best_score
    for _, p in ipairs(candidates) do
        local score = 0
        if vim.fn.fnamemodify(p, ":h") == current_dir then
            score = score + 1000
        end
        if prefer_images_dir and p:lower():find("/images/") then
            score = score + 100
        end
        local _, depth = p:gsub("/", "")
        score = score - depth
        if not best_score or score > best_score then
            best, best_score = p, score
        end
    end
    return best
end

local function find_note(ctx, target)
    if target:find("/") then -- vault-relative path, Obsidian style
        local p = ctx.vault .. "/" .. target
        if not p:lower():match("%.md$") then
            p = p .. ".md"
        end
        return vim.fn.filereadable(p) == 1 and p or nil
    end
    local candidates = ctx.index.md[target:lower()]
    return candidates and pick_best(candidates, ctx.current, false) or nil
end

local function find_image(ctx, name)
    if name:find("/") then
        local p = ctx.vault .. "/" .. name
        return vim.fn.filereadable(p) == 1 and p or nil
    end
    local candidates = ctx.index.img[name:lower()]
    return candidates and pick_best(candidates, ctx.current, true) or nil
end

-- ---------------------------------------------------------------------------
-- Markdown link transform
-- ---------------------------------------------------------------------------

local function parse_destination(raw)
    raw = vim.trim(raw)
    if vim.startswith(raw, "<") then
        local destination, suffix = raw:match("^<([^>]+)>(.*)$")
        return destination, suffix or ""
    end
    local destination, suffix = raw:match("^(%S+)(.*)$")
    return destination, suffix or ""
end

local function resolve_markdown_link(raw, ctx)
    local destination, suffix = parse_destination(raw)
    if not destination or destination == "" or vim.startswith(destination, "#") then
        return nil
    end
    if vim.startswith(destination, "//") or destination:match("^[%a][%w+.-]*:") then
        return nil
    end

    local path, header = destination:match("^(.-)#(.*)$")
    path = url_decode(path or destination):gsub("\\ ", " ")
    header = header and url_decode(header) or nil
    if path == "" or path:find("?", 1, true) or not is_markdown_file(path) then
        return nil
    end

    local resolved
    if vim.startswith(path, "/") then
        resolved = normalize_path(path)
    else
        resolved = normalize_path(vim.fs.joinpath(vim.fn.fnamemodify(ctx.current, ":p:h"), path))
    end
    if not path_is_within(resolved, ctx.root) or vim.fn.filereadable(resolved) ~= 1 then
        return nil
    end

    local url = string.format("http://127.0.0.1:%d/open?file=%s", ctx.port, url_encode(resolved))
    if header and header ~= "" then
        url = url .. "&header=" .. url_encode(header)
    end
    return url, suffix
end

local function rewrite_standard_links(seg, ctx)
    seg = seg:gsub("(!?)%[([^%]]-)%]%((.-)%)", function(image_marker, label, raw_destination)
        if image_marker == "!" then
            return string.format("![%s](%s)", label, raw_destination)
        end
        local url, suffix = resolve_markdown_link(raw_destination, ctx)
        if not url then
            return string.format("[%s](%s)", label, raw_destination)
        end
        return string.format("[%s](%s%s)", label, url, suffix)
    end)
    return seg
end

local function render_image(inner, ctx)
    local name, spec = inner:match("^(.-)|(.*)$")
    name = vim.trim(name or inner)
    local path = find_image(ctx, name)
    if not path then
        return string.format(
            '<span style="opacity:.6;border-bottom:1px dashed #c33">[missing image: %s]</span>',
            escape_html(inner)
        )
    end
    local alt = escape_html(name)
    if spec and spec ~= "" then
        local w, h = spec:match("^(%d+)x?(%d*)$")
        if w and h and h ~= "" then
            return string.format('<img src="%s" width="%s" height="%s" alt="%s" />', path, w, h, alt)
        elseif w then -- "|200" means width only in Obsidian
            return string.format('<img src="%s" width="%s" alt="%s" />', path, w, alt)
        end
        return string.format("![%s](%s)", spec, path) -- "|alt text" form
    end
    return string.format("![%s](%s)", alt, path)
end

local function render_link(inner, ctx)
    if inner:lower() == "toc" then -- vim/obsidian TOC placeholder, not a note link
        return "[[" .. inner .. "]]"
    end
    local target_part, alias = inner:match("^(.-)|(.*)$")
    target_part = target_part or inner
    local target, header = target_part:match("^(.-)#(.*)$")
    target = vim.trim(target or target_part)
    header = header and vim.trim(header) or nil

    local label = alias and vim.trim(alias) or ""
    if label == "" then
        label = header or target
    end

    local resolved
    if target == "" then -- [[#header]] -> current file
        resolved = ctx.current
    else
        resolved = find_note(ctx, target)
    end
    if not resolved then
        return string.format('<span style="opacity:.6;border-bottom:1px dashed #888">%s</span>', escape_html(label))
    end

    local url = string.format("http://127.0.0.1:%d/open?file=%s", ctx.port, url_encode(resolved))
    if header and header ~= "" then
        url = url .. "&header=" .. url_encode(header)
    end
    return string.format('<a href="%s">%s</a>', url, escape_html(label))
end

local function transform_segment(seg, ctx)
    if ctx.mode == "obsidian" then
        seg = seg:gsub("!%[%[([^%]]-)%]%]", function(inner)
            return render_image(inner, ctx)
        end)
        seg = seg:gsub("%[%[([^%]]-)%]%]", function(inner)
            return render_link(inner, ctx)
        end)
    end
    return rewrite_standard_links(seg, ctx)
end

-- Transform one line, skipping inline `code` spans (naive backtick alternation
-- is sufficient for note prose).
local function transform_line(line, ctx)
    local transformed
    if not line:find("`") then
        transformed = transform_segment(line, ctx)
    else
        local parts = vim.split(line, "`", { plain = true })
        for i = 1, #parts, 2 do -- odd positions are outside code spans
            parts[i] = transform_segment(parts[i], ctx)
        end
        transformed = table.concat(parts, "`")
    end

    -- Reference-style links keep their destination in a definition such as
    -- `[guide]: docs/guide.md#setup`. Rewrite that destination as well.
    local prefix, destination = transformed:match("^(%s*%[[^%]]+%]:%s*)(.+)$")
    if prefix then
        local url, suffix = resolve_markdown_link(destination, ctx)
        if url then
            return prefix .. url .. suffix
        end
    end
    return transformed
end

local function transform(content, ctx)
    local lines = vim.split(content, "\n", { plain = true })
    local in_fence = false
    local fence_char = nil
    for i, line in ipairs(lines) do
        local fence = line:match("^%s*(````*)") or line:match("^%s*(~~~~*)")
        if fence then
            local ch = fence:sub(1, 1)
            if not in_fence then
                in_fence, fence_char = true, ch
            elseif ch == fence_char then
                in_fence, fence_char = false, nil
            end
        elseif not in_fence then
            lines[i] = transform_line(line, ctx)
        end
    end
    return table.concat(lines, "\n")
end

-- ---------------------------------------------------------------------------
-- click-relay HTTP server
-- ---------------------------------------------------------------------------

local function http_write(client, status_line, extra_headers, body)
    local lines = { "HTTP/1.1 " .. status_line }
    vim.list_extend(lines, extra_headers or {})
    table.insert(lines, "Connection: close")
    if body then
        table.insert(lines, "Content-Length: " .. #body)
    end
    table.insert(lines, "")
    table.insert(lines, body or "")
    client:write(table.concat(lines, "\r\n"), function()
        pcall(function()
            client:shutdown()
            client:close()
        end)
    end)
end

local function jump_to_header(bufnr, header)
    if not header or header == "" then
        return
    end
    local target = vim.trim(header)
    local function slug(text)
        return text:lower()
            :gsub("<[^>]->", "")
            :gsub("[`*_~]", "")
            :gsub("%p", "")
            :gsub("%s+", "-")
            :gsub("%-+", "-")
            :gsub("^%-", "")
            :gsub("%-$", "")
    end
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local fallback = nil
    for i, line in ipairs(lines) do
        local text = line:match("^%s*#+%s*(.-)%s*$")
        if text and #text > 0 then
            if text == target then
                vim.api.nvim_win_set_cursor(0, { i, 0 })
                vim.cmd("normal! zz")
                return
            end
            if slug(text) == target:lower() then
                vim.api.nvim_win_set_cursor(0, { i, 0 })
                vim.cmd("normal! zz")
                return
            end
            if not fallback and text:lower() == target:lower() then
                fallback = i
            end
        end
    end
    if fallback then
        vim.api.nvim_win_set_cursor(0, { fallback, 0 })
        vim.cmd("normal! zz")
    end
end

local function open_note(file, header)
    -- uv callbacks may not call most of the vim API; defer everything.
    vim.schedule(function()
        file = normalize_path(file)
        local allowed = false
        for _, preview in pairs(state.previews) do
            if path_is_within(file, preview.root) then
                allowed = true
                break
            end
        end
        -- Only serve Markdown files below a root that has an active preview.
        if not is_markdown_file(file) or not allowed then
            notify("refused to open: " .. file, vim.log.levels.WARN)
            return
        end
        if vim.fn.filereadable(file) == 0 then
            notify("note not found: " .. file, vim.log.levels.WARN)
            return
        end
        local bufnr = vim.fn.bufadd(file)
        vim.fn.bufload(bufnr)
        vim.api.nvim_set_current_buf(bufnr)
        jump_to_header(bufnr, header)
        if not state.previews[bufnr] then
            M._start_preview(bufnr)
        end
    end)
end

local function handle_request(client, data)
    local path = data:match("^%u+%s+(%S+)")
    if not path then
        http_write(client, "400 Bad Request", nil, "bad request")
        return
    end
    local route, query = path:match("^([^?]*)%??(.*)$")
    if route == "/open" then
        local params = {}
        for kv in query:gmatch("[^&]+") do
            local k, v = kv:match("^([^=]*)=(.*)$")
            if k then
                params[k] = url_decode(v)
            end
        end
        -- 204 keeps the originating preview tab on screen after the click.
        http_write(client, "204 No Content")
        if params.file then
            open_note(params.file, params.header)
        end
    else
        http_write(client, "404 Not Found", nil, "not found")
    end
end

local function start_server()
    if state.server then
        return state.port
    end
    -- macOS lets a second bind() succeed on an already-listening loopback port
    -- (SO_REUSEADDR), so bind failure alone cannot detect busy ports -- probe
    -- with a real connect instead. A pid-derived offset also spreads ports
    -- across concurrent Neovim instances.
    local function port_free(port)
        local ok, chan = pcall(vim.fn.sockconnect, "tcp", "127.0.0.1:" .. port, { rpc = false })
        if ok and chan and chan > 0 then
            pcall(vim.fn.chanclose, chan)
            return false
        end
        return true
    end
    local srv, port
    local base = PORT_RANGE[1] + (uv.os_getpid() % 500)
    for candidate = base, PORT_RANGE[2] do
        if port_free(candidate) then
            local s = uv.new_tcp()
            if pcall(s.bind, s, "127.0.0.1", candidate) then
                srv, port = s, candidate
                break
            end
            pcall(s.close, s)
        end
    end
    if not port then
        notify("no free loopback port in " .. PORT_RANGE[1] .. "-" .. PORT_RANGE[2], vim.log.levels.ERROR)
        return nil
    end
    local ok, err = pcall(function()
        srv:listen(128, function(listen_err)
            if listen_err then
                return
            end
            local client = uv.new_tcp()
            srv:accept(client)
            local chunks = {}
            client:read_start(function(read_err, chunk)
                if read_err or not chunk then
                    pcall(function()
                        client:close()
                    end)
                    return
                end
                table.insert(chunks, chunk)
                local data = table.concat(chunks)
                if data:find("\r\n\r\n", 1, true) then
                    client:read_stop()
                    handle_request(client, data)
                end
            end)
        end)
    end)
    if not ok then
        pcall(srv.close, srv)
        notify("listen failed: " .. tostring(err), vim.log.levels.ERROR)
        return nil
    end
    state.server, state.port = srv, port
    return port
end

local function stop_server()
    if state.server then
        pcall(function()
            state.server:close()
        end)
        state.server, state.port = nil, nil
    end
end

-- ---------------------------------------------------------------------------
-- preview orchestration
-- ---------------------------------------------------------------------------

local function build_ctx(bufnr, port)
    local file = vim.api.nvim_buf_get_name(bufnr)
    local vault = find_vault_root(file)
    return {
        mode = vault and "obsidian" or "markdown",
        root = vault or find_project_root(file),
        vault = vault,
        port = port,
        current = file,
        index = vault and state.vaults[vault] or nil,
    }
end

function M._start_preview(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    if state.previews[bufnr] then
        return true
    end
    local file = vim.api.nvim_buf_get_name(bufnr)
    if file == "" or not is_markdown_file(file) or vim.fn.filereadable(file) ~= 1 then
        notify("current buffer is not a readable Markdown file", vim.log.levels.WARN)
        return false
    end
    local vault = find_vault_root(file)
    local port = start_server()
    if not port then
        return false
    end
    if vault then
        scan_vault(vault)
    end

    -- scratch buffer holding the rewritten content; named inside the same
    -- directory so markdown-preview resolves local images correctly.
    local temp = vim.api.nvim_create_buf(false, true)
    local name = vim.fn.fnamemodify(file, ":h") .. "/.markdown-preview-" .. vim.fn.fnamemodify(file, ":t")
    pcall(vim.api.nvim_buf_set_name, temp, name)
    vim.bo[temp].filetype = "markdown"
    vim.bo[temp].buflisted = false
    vim.bo[temp].swapfile = false

    local ctx = build_ctx(bufnr, port)
    local function refresh()
        if not (vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_is_valid(temp)) then
            return
        end
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local out = transform(table.concat(lines, "\n"), ctx)
        vim.bo[temp].modifiable = true
        vim.api.nvim_buf_set_lines(temp, 0, -1, false, vim.split(out, "\n", { plain = true }))
        vim.bo[temp].modifiable = false
        vim.bo[temp].modified = false
    end
    refresh()

    local group = vim.api.nvim_create_augroup("SmartMarkdownPreview" .. bufnr, { clear = true })

    -- mirror edits from the real buffer so the preview stays in sync.
    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
        group = group,
        buffer = bufnr,
        callback = function()
            refresh()
            if vim.api.nvim_buf_is_valid(temp) then
                vim.api.nvim_buf_call(temp, function()
                    pcall(vim.fn["mkdp#rpc#preview_refresh"])
                end)
            end
        end,
    })

    -- start the preview on the scratch buffer, then switch straight back;
    -- mkdp_auto_close must be 0 at init time or BufHidden kills the page.
    local win = vim.api.nvim_get_current_win()
    local prev_buf = vim.api.nvim_get_current_buf()
    -- a recycled bufnr may still have the mkdp augroup of a previous preview;
    -- clear it so the readiness wait below cannot fire early.
    pcall(vim.api.nvim_del_augroup_by_name, "MKDP_REFRESH_INIT" .. temp)
    vim.api.nvim_win_set_buf(win, temp)
    local saved_auto_close = vim.g.mkdp_auto_close
    vim.g.mkdp_auto_close = 0
    local server_running = vim.fn["mkdp#rpc#get_server_status"]() == 1
    local ok, err = pcall(vim.cmd, "MarkdownPreview")
    if ok and not server_running then
        -- The first :MarkdownPreview only boots the node server; the browser
        -- page is opened later by the server itself calling back into
        -- mkdp#util#open_browser(), which resolves bufnr('%') at *that*
        -- async moment. Keep the scratch buffer current until that callback
        -- lands (it creates the MKDP_REFRESH_INIT<temp> augroup), otherwise
        -- the page opens for the original buffer and shows raw content.
        local ready = vim.wait(5000, function()
            local ok_grp, acs = pcall(vim.api.nvim_get_autocmds, { group = "MKDP_REFRESH_INIT" .. temp })
            return ok_grp and #acs > 0
        end, 20)
        if not ready then
            notify("preview server did not open the page in time", vim.log.levels.WARN)
        end
    end
    vim.g.mkdp_auto_close = saved_auto_close
    if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_set_buf(win, prev_buf)
    end
    if not ok then
        pcall(vim.api.nvim_buf_delete, temp, { force = true })
        pcall(vim.api.nvim_del_augroup_by_id, group)
        notify("MarkdownPreview failed: " .. tostring(err), vim.log.levels.ERROR)
        return false
    end

    state.previews[bufnr] = {
        temp = temp,
        group = group,
        orig = bufnr,
        mode = ctx.mode,
        root = ctx.root,
    }

    vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
        group = group,
        buffer = bufnr,
        once = true,
        callback = function()
            M.stop(bufnr)
        end,
    })
    vim.api.nvim_create_autocmd("BufWipeout", {
        group = group,
        buffer = temp,
        once = true,
        callback = function()
            M.stop(bufnr)
        end,
    })

    if not state.leave_autocmd then
        state.leave_autocmd = true
        vim.api.nvim_create_autocmd("VimLeavePre", {
            callback = function()
                M.stop_all()
            end,
        })
    end
    return true
end

function M.stop(bufnr)
    local p = state.previews[bufnr]
    if not p then
        return
    end
    state.previews[bufnr] = nil
    pcall(vim.api.nvim_del_augroup_by_id, p.group)
    if vim.api.nvim_buf_is_valid(p.temp) then
        vim.api.nvim_buf_call(p.temp, function()
            pcall(vim.cmd, "MarkdownPreviewStop")
        end)
        pcall(vim.api.nvim_buf_delete, p.temp, { force = true })
    end
    if vim.tbl_isempty(state.previews) then
        stop_server()
    end
end

function M.stop_all()
    for bufnr in pairs(state.previews) do
        M.stop(bufnr)
    end
    stop_server()
end

--- Toggle the smart preview for the current buffer. Obsidian syntax is enabled
--- only when an ancestor `.obsidian` directory is present.
function M.toggle()
    local bufnr = vim.api.nvim_get_current_buf()
    if state.previews[bufnr] then
        M.stop(bufnr)
        return
    end
    M._start_preview(bufnr)
end

return M
