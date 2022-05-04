local plugin = {}

plugin.core = {
    "navarasu/onedark.nvim",
    as = 'onedark',
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded

    end,
}

plugin.mapping = function()

end

plugin.light = {

}

plugin.dark = {

}
plugin.setup = function (style)
    vim.cmd("packadd onedark")
    local onedark = require('onedark')
    if vim.g.style == "light" then
        onedark.setup({
          style = 'light'
        })
    else
        onedark.setup({
          style = 'light', -- Or
        })
    end
    onedark.load()
    local timer = vim.loop.new_timer()
    timer:start(vim.g.after_schedule_time_start+100, 0, vim.schedule_wrap(function()
        vim.cmd("hi! default link NormalFloat Pmenu")
        vim.cmd("hi! default link WhichKeyFloat Pmenu")
        vim.cmd("hi FgCocWarningFloatBgCocFloating ctermfg=130 guibg=#434c5e ctermbg=13 guifg=#ff922b")
        vim.cmd("hi FgCocErrorFloatBgCocFloating ctermfg=9 ctermbg=13 guibg=#434c5e guifg=#ff0000")
        vim.cmd("hi FgCocHintFloatBgCocFloating guibg=#434c5e ctermbg=13 ctermfg=11 guifg=#fab005")
    end))
end

return plugin
