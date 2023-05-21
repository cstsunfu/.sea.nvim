local plugin = {}

plugin.core = {
    "sainnhe/gruvbox-material",
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded

    end,
}

plugin.mapping = function()
end

plugin.light = function()
    vim.cmd("set background=light")
    vim.cmd("let g:gruvbox_material_background = 'medium'")
    vim.cmd("colorscheme gruvbox-material")
end

plugin.dark = function ()
    vim.cmd("set background=dark")
    vim.cmd("let g:gruvbox_material_background = 'medium'")
    vim.cmd("colorscheme gruvbox-material")
end

plugin.setup = function (style)
    vim.cmd("packadd gruvbox-material")
    if style == "light" then
        plugin.light()
    else
        plugin.dark()
    end
    local timer = vim.loop.new_timer()
    vim.cmd("hi clear Search")
    timer:start(vim.g.after_schedule_time_start+100, 0, vim.schedule_wrap(function()
        vim.cmd("hi clear Search")
        vim.cmd("hi! Search ctermfg=black ctermbg=142 guifg=Black guibg=#a9b665")
    end))
end

return plugin
