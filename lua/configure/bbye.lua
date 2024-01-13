local plugin = {}

plugin.core = {
    "moll/vim-bbye",
    event = "BufEnter",
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
    end,
}

plugin.mapping = function() end
return plugin
