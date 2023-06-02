local plugin = {}

plugin.core = {
    "rcarriga/nvim-notify",
    init = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        vim.notify = require("notify")
    end,
}

plugin.mapping = function()

end
return plugin
