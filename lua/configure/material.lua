local plugin = {}

plugin.core = {
    "marko-cerovac/material.nvim",
    as = "material",
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
plugin.setup = function (theme)
    vim.cmd("packadd material")
    if vim.g.theme == "light" then
        vim.g.material_style = 'ocean'
    elseif vim.g.theme == 'midium' then
        vim.g.material_style = 'palenight'
    else
        vim.g.material_style = 'darker'
    end
    vim.cmd 'colorscheme material'
    local timer = vim.loop.new_timer()
    timer:start(500, 0, vim.schedule_wrap(function()
        vim.cmd("hi! default link WhichKeyFloat Pmenu")
        vim.cmd("hi! default link NormalFloat Pmenu")

        vim.cmd("hi! DiffDelete guibg=#A6647A")
        vim.cmd("hi FgCocWarningFloatBgCocFloating ctermfg=130 guibg=#434c5e ctermbg=13 guifg=#ff922b")
        vim.cmd("hi FgCocErrorFloatBgCocFloating ctermfg=9 ctermbg=13 guibg=#434c5e guifg=#ff0000")
        vim.cmd("hi FgCocHintFloatBgCocFloating guibg=#434c5e ctermbg=13 ctermfg=11 guifg=#fab005")
    end))
end

return plugin
