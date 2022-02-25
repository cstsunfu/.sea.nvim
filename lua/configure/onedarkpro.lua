local plugin = {}

plugin.core = {
    "olimorris/onedarkpro.nvim",
    as = "onedarkpro",
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
    vim.cmd("packadd onedarkpro")
    if theme == "light" then
        plugin.light()
    else
        plugin.dark()
    end
    local timer = vim.loop.new_timer()
    timer:start(500, 0, vim.schedule_wrap(function()
        vim.cmd("hi! default link NormalFloat Pmenu")
    end))
end

return plugin
