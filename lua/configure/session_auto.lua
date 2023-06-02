local plugin = {}

plugin.core = {
    "folke/persistence.nvim",
    --event = {"BufReadPre"},
    setup = function()  -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require('persistence').setup({})
    end,
}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = {"<leader>", "s", "l"},
        action = '<cmd>lua require("persistence").load()<cr>',
        short_desc = "Load Session(Dir)",
        silent = true
    })

end

return plugin
