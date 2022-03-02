local plugin = {}

plugin.core = {
    "kevinhwang91/nvim-hlslens",
    --as = "nvim-hlslens",
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
    end,
}

plugin.mapping = function()

    vim.cmd("noremap <silent> n <Cmd>execute('normal! ' . v:count1 . 'n')<CR> <Cmd>lua require('hlslens').start()<CR>")
    vim.cmd("noremap <silent> N <Cmd>execute('normal! ' . v:count1 . 'N')<CR> <Cmd>lua require('hlslens').start()<CR>")
    vim.cmd("noremap * *<Cmd>lua require('hlslens').start()<CR>")
    vim.cmd("noremap # #<Cmd>lua require('hlslens').start()<CR>")
    vim.cmd("noremap g* g*<Cmd>lua require('hlslens').start()<CR>")
    vim.cmd("noremap g# g#<Cmd>lua require('hlslens').start()<CR>")
    --vim.api.nvim_set_keymap("n", "n", "<Cmd>execute('normal! ' . v:count1 . 'n')<CR> <Cmd>lua require('hlslens').start()<CR>", {silent=true})
    --vim.api.nvim_set_keymap("n", "N", "<Cmd>execute('normal! ' . v:count1 . 'N')<CR> <Cmd>lua require('hlslens').start()<CR>", {silent=true})
    --vim.api.nvim_set_keymap("n", "*", "*<Cmd>lua require('hlslens').start()<CR>", {})
    --vim.api.nvim_set_keymap("n", "#", "#<Cmd>lua require('hlslens').start()<CR>", {})
    --vim.api.nvim_set_keymap("n", "g#", "g#<Cmd>lua require('hlslens').start()<CR>", {})
    --vim.api.nvim_set_keymap("n", "g*", "g*<Cmd>lua require('hlslens').start()<CR>", {})

end

return plugin
