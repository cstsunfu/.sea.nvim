local plugin = {}

plugin.core = {
    "git@github.com:dhruvasagar/vim-table-mode.git",
    as = "vim-table-mode",
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
    end,
}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = {"<leader>", "t", "m"},
        action = ':TableModeToggle<cr>',
        short_desc = "Toggle Table Mode",
        silent = true
    })

end

return plugin
