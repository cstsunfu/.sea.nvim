local plugin = {}

plugin.core = {
    "kevinhwang91/nvim-hlslens",
    event = 'VeryLazy',
    init = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require('hlslens').setup()
        local timer = vim.loop.new_timer()
        timer:start(vim.g.after_schedule_time_start+100, 0, vim.schedule_wrap(function()
            vim.cmd("hi clear HlSearchLens")
            vim.cmd("hi default link HlSearchLens Search")
            vim.cmd("hi clear HlSearchLensNear")
            vim.cmd("hi default link HlSearchLensNear CurSearch")
        end))
    end,
}

plugin.mapping = function()
    local kopts = {noremap = true, silent = true}
    vim.api.nvim_set_keymap('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
    vim.api.nvim_set_keymap('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]], kopts)
    vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
    vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
    vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
    vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
end

return plugin
