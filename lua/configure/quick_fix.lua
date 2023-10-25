local plugin = {}

plugin.core = {
    "kevinhwang91/nvim-bqf",
    ft = { "qf" },
    init = function() -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        -- Utilities for creating configurations
        require('bqf').setup()
    end,
}

plugin.mapping = function()

end

return plugin
