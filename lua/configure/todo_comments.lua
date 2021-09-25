local plugin = {}

plugin.core = {
    "git@github.com:folke/todo-comments.nvim.git",
    as = "todo-comments",
    --requires = {{"git@github.com:nvim-lua/plenary.nvim.git", as = "plenary.nvim"}, {"git@github.com:nvim-telescope/telescope.nvim.git", as="telescope"}, {"git@github.com:nvim-lua/popup.nvim.git", as="popup"}},
    after = {"plenary.nvim", "telescope.nvim", "popup.nvim"},
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
