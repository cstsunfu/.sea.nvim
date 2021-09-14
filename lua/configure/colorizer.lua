local plugin = {}

plugin.core = {
    "git@github.com:norcalli/nvim-colorizer.lua.git",
    as = "nvim-colorizer",
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require'colorizer'.setup()
    end,
}

plugin.mapping = function()

end
return plugin
