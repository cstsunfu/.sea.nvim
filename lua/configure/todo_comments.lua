local plugin = {}

plugin.core = {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("todo-comments").setup {
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
        key = {"<leader>", "t", "t"},
        action = ':TodoTelescope<cr>',
        short_desc = "Toggle TODO List",
        silent = true
    })

end

return plugin
