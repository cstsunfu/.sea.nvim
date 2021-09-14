local plugin = {}

plugin.core = {
    "git@github.com:danymat/neogen.git",
    as = "neogen",

    requires = {{"git@github.com:nvim-treesitter/nvim-treesitter.git", as = "nvim-treesitter"}},

    setup = function()  -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require('neogen').setup {
            enabled = true
        }
    end
}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = {"<leader>", "g", "a"},
        action = ":lua require('neogen').generate()<cr>",
        short_desc = "Generate Annotation",
        noremap = true,
        silent = true,
    })
end

return plugin
