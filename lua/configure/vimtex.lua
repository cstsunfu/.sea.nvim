local plugin = {}

plugin.core = {
    "lervag/vimtex",
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        vim.g.vimtex_syntax_conceal_disable = 1
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
end

return plugin
