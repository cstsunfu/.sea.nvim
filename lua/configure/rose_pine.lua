local plugin = {}

plugin.core = {
    "git@github.com:rose-pine/neovim.git",
    as = 'rose-pine',

    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded

    end,
}

plugin.mapping = function()

end

plugin.light = function()
    vim.g.rose_pine_variant = 'dawn'
    vim.cmd("colorscheme rose-pine")
end

plugin.dark = function ()
    vim.g.rose_pine_variant = 'moon'
    vim.cmd("colorscheme rose-pine")
end

plugin.setup = function (theme)
    vim.cmd("packadd rose-pine")
    if theme == "light" then
        plugin.light()
    else
        plugin.dark()
    end
end
return plugin
