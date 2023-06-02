local plugin = {}

plugin.core = {
    "rose-pine/neovim",

    init = function()  -- Specifies code to run before this plugin is loaded.

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

plugin.setup = function (style)
    if style == "light" then
        plugin.light()
    else
        plugin.dark()
    end
end
return plugin
