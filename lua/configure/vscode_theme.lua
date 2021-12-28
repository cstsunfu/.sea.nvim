local plugin = {}

plugin.core = {
    "git@github.com:Mofiqul/vscode.nvim.git",
    as = "vscode.nvim",
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded

    end,
}

plugin.mapping = function()
end

plugin.light = function()
    -- For light theme
    vim.g.vscode_style = "light"
    vim.cmd[[colorscheme vscode]]
end

plugin.dark = function ()
    -- For dark theme
    vim.g.vscode_style = "dark"
    vim.cmd[[colorscheme vscode]]
end

plugin.setup = function (theme)
    vim.cmd("packadd vscode.nvim")
    if theme == "light" then
        plugin.light()
    else
        plugin.dark()
    end
end

return plugin
