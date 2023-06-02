local plugin = {}

plugin.core = {
    "Mofiqul/vscode.nvim",
    init = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded

    end,
}

plugin.mapping = function()
end

plugin.light = function()
    -- For light style
    vim.g.vscode_style = "light"
    vim.cmd[[colorscheme vscode]]
end

plugin.dark = function ()
    -- For dark style
    vim.g.vscode_style = "dark"
    vim.cmd[[colorscheme vscode]]
end

plugin.setup = function (style)
    if style == "light" then
        plugin.light()
    else
        plugin.dark()
    end
    local timer = vim.loop.new_timer()
    timer:start(vim.g.after_schedule_time_start+100, 0, vim.schedule_wrap(function()
        vim.cmd("hi! DiffDelete guibg=#A6647A")
    end))
end

return plugin
