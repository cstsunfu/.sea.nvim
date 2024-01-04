local plugin = {}

plugin.core = {
    "rcarriga/nvim-notify",
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("notify").setup({
            background_colour = "#000000",
        })
        vim.notify = require("notify")
    end,
}

plugin.mapping = function() end
return plugin
