local plugin = {}

plugin.core = {
    "navarasu/onedark.nvim",
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
    end,
}

plugin.mapping = function() end


plugin.setup = function(style)
    local onedark = require("onedark")
    if vim.g.style == "light" then
        onedark.setup({
            style = "light",
        })
    else
        onedark.setup({
            style = "dark", -- Or
        })
    end
    onedark.load()
    require("util.highlight").apply_theme_overrides()
end

return plugin
