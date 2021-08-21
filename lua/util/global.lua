local func = {}
local uv = vim.loop

func.delete_all_buffers_in_window = function ()
    local cur_win_nr = vim.fn.bufnr("%")
    vim.cmd("bn")
    local next_win_nr = vim.fn.bufnr("%")
    while cur_win_nr ~= next_win_nr do
        vim.cmd("bd "..next_win_nr)
        vim.cmd("bn")
        next_win_nr = vim.fn.bufnr("%")
    end
end


func.augroup = function(name, commands)
    vim.cmd('augroup ' .. name)
    vim.cmd 'autocmd!'
    for _, c in ipairs(commands) do
        local command = c.command
        vim.cmd(
            string.format(
                'autocmd %s %s %s %s',
                table.concat(c.events, ','),
                table.concat(c.targets or {}, ','),
                table.concat(c.modifiers or {}, ' '),
                command
            )
        )
    end
    vim.cmd 'augroup END'
end

func.index = function(tab, key)
    if not tab then
        return nil
    end
    for idx,val in ipairs(tab) do
        if key == val then
            return idx
        end
    end
    return nil
end

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

func.sync_write_file = function(path, data)
    local fd = assert(uv.fs_open(path, "w", 438))
    assert(uv.fs_read(fd, data, 0))
    assert(uv.fs_close(fd))
end

func.menu = function(title, items, prompt)
    local content = { title .. ':' }
    local valid_keys = {}
    for _, item in ipairs(items) do
        if item.separator then
            table.insert(content, string.rep(item.separator or '-', item.length or 80))
        else
            valid_keys[item.key] = item
            table.insert(content, string.format('%s %s', item.key, item.label))
        end
    end
    prompt = prompt or 'key'
    table.insert(content, prompt .. ': ')
    vim.cmd(string.format('echon "%s"', table.concat(content, '\\n')))
    local char = vim.fn.nr2char(vim.fn.getchar())
    vim.cmd([[redraw!]])
    local entry = valid_keys[char]
    if not entry or not entry.action then
        return
    end
    return entry.action()
end

func.split = function(str, _sep)
    local sep, fields = _sep or "\t", {}
    string.gsub(str, '[^'..sep..']+', function(w) table.insert(fields, w) end )
    return fields
end

return func
