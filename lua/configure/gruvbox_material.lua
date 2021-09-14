local plugin = {}

plugin.core = {
    "git@github.com:sainnhe/gruvbox-material.git",
    as = "gruvbox-material",
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded

    end,
}

plugin.mapping = function()
end

plugin.light = function()
    vim.cmd("set background=light")
    vim.cmd("let g:gruvbox_material_background = 'soft'")
    vim.cmd("colorscheme gruvbox-material")
end

plugin.dark = function ()
    vim.cmd("set background=dark")
    vim.cmd("let g:gruvbox_material_background = 'soft'")
    vim.cmd("colorscheme gruvbox-material")
end

plugin.setup = function (theme)
    vim.cmd("packadd gruvbox-material")
    if theme == "light" then
        plugin.light()
    else
        plugin.dark()
    end
end

return plugin
