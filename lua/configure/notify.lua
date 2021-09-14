local plugin = {}

plugin.core = {
    "git@github.com:rcarriga/nvim-notify.git",
    as = "nvim-notify",
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        vim.notify = require("notify")
    end,
}

plugin.mapping = function()

end
return plugin
