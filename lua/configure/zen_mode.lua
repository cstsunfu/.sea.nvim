local plugin = {}

plugin.core = {
    "folke/zen-mode.nvim",
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("zen-mode").setup {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    end,
}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = {"<leader>", "t", "o"},
        action = ':ZenMode<cr>',
        short_desc = "Toggle Only Window(ZenMode)",
        silent = true
    })

end

return plugin
