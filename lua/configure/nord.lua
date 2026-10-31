local plugin = {}

plugin.core = {
    "shaunsingh/nord.nvim",

    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
    end,
}

plugin.mapping = function() end

plugin.setup = function()
    -- nord ships a single palette; both styles load the same one.
    vim.o.background = vim.g.style == "light" and "light" or "dark"
    require("nord").set()
    require("util.highlight").apply_theme_overrides({ cursor = true })
end
return plugin
