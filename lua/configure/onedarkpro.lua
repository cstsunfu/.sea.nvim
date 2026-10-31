local plugin = {}

plugin.core = {
    "olimorris/onedarkpro.nvim",
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
    end,
}

plugin.mapping = function() end

plugin.light = function()
    -- For light style
    vim.o.background = "light"
    require("onedarkpro").load()
end

plugin.dark = function()
    -- For dark style
    vim.o.background = "dark"
    require("onedarkpro").load()
end

plugin.setup = function(style)
    if style == "light" then
        plugin.light()
        vim.cmd("hi CursorLine guibg=#e3e3e3")
    else
        plugin.dark()
    end
    require("util.highlight").apply_theme_overrides({ cursor = true })
end

return plugin
