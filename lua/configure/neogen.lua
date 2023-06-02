local plugin = {}

plugin.core = {
    "danymat/neogen",

    dependencies = { 'nvim-treesitter' },
    init = function() -- Specifies code to run before this plugin is loaded.
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
        key = { "<leader>", "g", "n" },
        action = ":lua require('neogen').generate()<cr>",
        short_desc = "Generate Note",
        noremap = true,
        silent = true,
    })
end

return plugin
