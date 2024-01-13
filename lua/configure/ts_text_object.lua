local plugin = {}
plugin.core = {
    "mfussenegger/nvim-ts-hint-textobject",
    event = "VeryLazy",
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("tsht").config.hint_keys = { "h", "j", "f", "d", "n", "v", "s", "l", "a" }
    end,
}

plugin.mapping = function()
    vim.cmd("omap <silent> m :<C-U>lua require('tsht').nodes()<CR>")
    vim.cmd("vnoremap <silent> m :lua require('tsht').nodes()<CR>")
end
return plugin
