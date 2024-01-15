local plugin = {}

plugin.core = {
    "glacambre/firenvim",
    event = "VeryLazy",
    build = function()
        vim.fn["firenvim#install"](0)
    end,
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
    end,
}

plugin.mapping = function() end
return plugin
