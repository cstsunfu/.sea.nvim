func = {}

func.DeleteAllBuffersInWindow = function ()
    local cur_win_nr = vim.fn.bufnr("%")
    vim.cmd("bn")
    local next_win_nr = vim.fn.bufnr("%")
    while cur_win_nr ~= next_win_nr do
        vim.cmd("bd "..next_win_nr)
        vim.cmd("bn")
        next_win_nr = vim.fn.bufnr("%")
    end
end

return func
