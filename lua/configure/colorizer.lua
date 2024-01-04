local plugin = {}

plugin.core = {
    "norcalli/nvim-colorizer.lua",
    ft = { "lua", "vim", "html", "css", "markdown", "python", "vue", "js", "ts" },
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("colorizer").setup()
    end,
}

plugin.mapping = function() end
return plugin
