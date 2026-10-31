local func = {}
local uv = vim.loop

-- highlight
local hl_fun = require("util.highlight")
func.get_highlight_values = hl_fun.get_highlight_values
func.highlight = hl_fun.highlight
func.brighten = hl_fun.brighten
func.colors = hl_fun.colors

-- delete buffers
func.delete_all_buffers_in_window = function()
    local cur_win_nr = vim.fn.bufnr("%")
    vim.cmd("bn")
    local next_win_nr = vim.fn.bufnr("%")
    while cur_win_nr ~= next_win_nr do
        vim.cmd("bd " .. next_win_nr)
        vim.cmd("bn")
        next_win_nr = vim.fn.bufnr("%")
    end
end

func.enable_large_buf = function()
    vim.b.large_buf = true
    vim.notify("Large buffer.", "info", { title = "Large buffer" })
    vim.cmd("syntax off")
    --vim.cmd("IlluminatePauseBuf") -- disable vim-illuminate
    vim.opt_local.foldmethod = "manual"
    if vim.fn.exists(":TSBufDisable") then
        pcall(vim.cmd, "TSBufDisable autotag")
        pcall(vim.cmd, "TSBufDisable highlight")
        pcall(vim.cmd, "TSBufDisable incremental_selection")
        pcall(vim.cmd, "TSBufDisable indent")
        pcall(vim.cmd, "TSBufDisable playground")
        pcall(vim.cmd, "TSBufDisable query_linter")
        pcall(vim.cmd, "TSBufDisable rainbow")
        pcall(vim.cmd, "TSBufDisable refactor.highlight_definitions")
        pcall(vim.cmd, "TSBufDisable refactor.navigation")
        pcall(vim.cmd, "TSBufDisable refactor.smart_rename")
        pcall(vim.cmd, "TSBufDisable refactor.highlight_current_scope")
        pcall(vim.cmd, "TSBufDisable textobjects.swap")
        pcall(vim.cmd, "TSBufDisable textobjects.move")
        pcall(vim.cmd, "TSBufDisable textobjects.lsp_interop")
        pcall(vim.cmd, "TSBufDisable textobjects.select")
    end
    vim.opt_local.spell = false
end

func.disable_large_buf = function()
    vim.b.large_buf = false
    vim.cmd("syntax on")

    vim.opt_local.foldmethod = "indent"
    if vim.fn.exists(":TSBufEnable") then
        pcall(vim.cmd, "TSBufEnable autotag")
        pcall(vim.cmd, "TSBufEnable highlight")
        pcall(vim.cmd, "TSBufEnable incremental_selection")
        pcall(vim.cmd, "TSBufEnable indent")
        pcall(vim.cmd, "TSBufEnable playground")
        pcall(vim.cmd, "TSBufEnable query_linter")
        pcall(vim.cmd, "TSBufEnable rainbow")
        pcall(vim.cmd, "TSBufEnable refactor.highlight_definitions")
        pcall(vim.cmd, "TSBufEnable refactor.navigation")
        pcall(vim.cmd, "TSBufEnable refactor.smart_rename")
        pcall(vim.cmd, "TSBufEnable refactor.highlight_current_scope")
        pcall(vim.cmd, "TSBufEnable textobjects.swap")
        pcall(vim.cmd, "TSBufEnable textobjects.move")
        pcall(vim.cmd, "TSBufEnable textobjects.lsp_interop")
        pcall(vim.cmd, "TSBufEnable textobjects.select")
    end
end

-- list all files in current directory escape the hidden files
func.scandir = function(directory)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen("find " .. directory .. ' -name "*" -not -path "*/.*" -print ')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = { filename, tostring(i) }
    end
    pfile:close()
    return t
end

-- augroup
func.augroup = function(name, commands)
    vim.cmd("augroup " .. name)
    vim.cmd("autocmd!")
    for _, c in ipairs(commands) do
        local command = c.command
        vim.cmd(
            string.format(
                "autocmd %s %s %s %s",
                table.concat(c.events, ","),
                table.concat(c.targets or {}, ","),
                table.concat(c.modifiers or {}, " "),
                command
            )
        )
    end
    vim.cmd("augroup END")
end

-- get the index of the key in the table
func.index = function(tab, key)
    if not tab then
        return nil
    end
    for idx, val in ipairs(tab) do
        if key == val then
            return idx
        end
    end
    return nil
end

-- async read file
func.async_read_file = function(path, callback)
    uv.fs_open(path, "r", 438, function(err, fd)
        --assert(not err, err)
        if err then
            return nil
        end
        uv.fs_fstat(fd, function(err, stat)
            if err then
                return nil
            end
            uv.fs_read(fd, stat.size, 0, function(err, data)
                assert(not err, err)
                uv.fs_close(fd, function(err)
                    assert(not err, err)
                    return callback(data)
                end)
            end)
        end)
    end)
end

-- sync read file
func.sync_read_file = function(path)
    local fd, err = uv.fs_open(path, "r", 438)
    if err then
        return nil
    end
    local stat = assert(uv.fs_fstat(fd))
    local data = assert(uv.fs_read(fd, stat.size, 0))
    assert(uv.fs_close(fd))
    return data
end

func.async_write_file = function(path, data)
    uv.fs_open(path, "w", 438, function(err, fd)
        --assert(not err, err)
        if err then
            print(err)
            return nil
        end
        uv.fs_write(fd, data, 0, function(err, bytes)
            assert(not err, err)
            uv.fs_close(fd)
        end)
    end)
end

-- select item from menu
func.menu = function(title, items, prompt)
    local content = { title .. ":" }
    local valid_keys = {}
    for _, item in ipairs(items) do
        if item.separator then
            table.insert(content, string.rep(item.separator or "-", item.length or 80))
        else
            valid_keys[item.key] = item
            table.insert(content, string.format("%s %s", item.key, item.label))
        end
    end
    prompt = prompt or "key"
    table.insert(content, prompt .. ": ")
    vim.cmd(string.format('echon "%s"', table.concat(content, "\\n")))
    local char = vim.fn.nr2char(vim.fn.getchar())
    vim.cmd([[redraw!]])
    local entry = valid_keys[char]
    if not entry or not entry.action then
        return
    end
    return entry.action()
end

-- split string
func.split = function(str, _sep)
    local sep, fields = _sep or "\t", {}
    string.gsub(str, "[^" .. sep .. "]+", function(w)
        table.insert(fields, w)
    end)
    return fields
end

return func
