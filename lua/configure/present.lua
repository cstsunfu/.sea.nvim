local plugin = {}

plugin.core = {
    --"sotte/presenting.vim",
    "Chaitanyabsprip/present.nvim",
    cmd = "Present",
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
    end,
}

plugin.mapping = function() end

return plugin
