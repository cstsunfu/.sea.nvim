local plugin = {}

plugin.core = {
    "git@github.com:olimorris/onedarkpro.nvim.git",
    as = "onedarkpro.nvim",
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded

    end,
}

plugin.mapping = function()
end

plugin.light = function()
    -- For light theme
    vim.o.background = "light"
    require('onedarkpro').load()
end

plugin.dark = function ()
    -- For dark theme
    vim.o.background = "dark"
    require('onedarkpro').load()
end

plugin.setup = function (theme)
    vim.cmd("packadd onedarkpro.nvim")
    if theme == "light" then
        plugin.light()
    else
        plugin.dark()
    end
end

return plugin
