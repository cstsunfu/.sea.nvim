local plugin = {}

plugin.core = {
    "hjson/vim-hjson",
    ft = { "hjson" },
    init = function() -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
    end,
}

plugin.mapping = function()

end

return plugin
