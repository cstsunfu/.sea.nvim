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
    -- For light style
    vim.o.background = "light"
    require('onedarkpro').load()
end

plugin.dark = function ()
    -- For dark style
    vim.o.background = "dark"
    require('onedarkpro').load()
end

plugin.setup = function (style)
    vim.cmd("packadd onedarkpro")
    if style == "light" then
        plugin.light()
    else
        plugin.dark()
    end
    local timer = vim.loop.new_timer()
    timer:start(500, 0, vim.schedule_wrap(function()
        vim.cmd("hi! default link NormalFloat Pmenu")
        vim.cmd("hi! default link WhichKeyFloat Pmenu")
        vim.cmd("hi FgCocWarningFloatBgCocFloating ctermfg=130 guibg=#434c5e ctermbg=13 guifg=#ff922b")
        vim.cmd("hi FgCocErrorFloatBgCocFloating ctermfg=9 ctermbg=13 guibg=#434c5e guifg=#ff0000")
        vim.cmd("hi FgCocHintFloatBgCocFloating guibg=#434c5e ctermbg=13 ctermfg=11 guifg=#fab005")
    end))
end

return plugin
