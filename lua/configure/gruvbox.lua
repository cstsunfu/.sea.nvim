local plugin = {}

plugin.core = {
    "morhetz/gruvbox",
    --as = "gruvbox",
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded

    end,
}

plugin.mapping = function()
end

plugin.light = function()
    vim.cmd("set background=light")
    vim.cmd("colorscheme gruvbox")
end

plugin.dark = function ()
    vim.cmd("set background=dark")
    vim.cmd("colorscheme gruvbox")
end

plugin.setup = function (theme)
    vim.cmd("packadd gruvbox")
    if theme == "light" then
        plugin.light()
    else
        plugin.dark()
    end
end

return plugin
