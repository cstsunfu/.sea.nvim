local plugin = {}

plugin.core = {
    "windwp/nvim-autopairs",
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("nvim-autopairs").setup({})
    end,
}

plugin.mapping = function() end

return plugin
