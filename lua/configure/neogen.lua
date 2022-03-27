local plugin = {}

plugin.core = {
    "danymat/neogen",

    after = {'nvim-treesitter'},
    setup = function()  -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        if not packer_plugins['nvim-treesitter'].loaded then
            vim.cmd [[packadd nvim-treesitter]]
        end

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
