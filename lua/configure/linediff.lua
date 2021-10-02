local plugin = {}

plugin.core = {
    "git@github.com:AndrewRadev/linediff.vim.git",
    as = "linediff",
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded

    end,

}


plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "v",
        key = {"<leader>", "l", "d"},
        action = ":'<,'>Linediff<cr>",
        short_desc = "Line Diff",
        noremap = true,
    })

end
return plugin
