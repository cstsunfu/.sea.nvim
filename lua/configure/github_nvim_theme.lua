local plugin = {}

plugin.core = {
    "projekt0n/github-nvim-theme",
    --as = "github-nvim-theme",

    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded

    end,
}

plugin.mapping = function()
end

plugin.light = {
    themeStyle = "light"
}

plugin.dark = {
-- default dark is better
}

plugin.setup = function (theme)
    if theme == "light" then
        require('github-theme').setup(plugin.light)
    else
        require('github-theme').setup(plugin.dark)
    end
end

return plugin
