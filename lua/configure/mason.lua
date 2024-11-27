local plugin = {}

plugin.core = {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        -- Utilities for creating configurations
        require("mason").setup({
            pip = {
                ---@since 1.0.0
                -- Whether to upgrade pip to the latest version in the virtual environment before installing packages.
                upgrade_pip = false,
                -- Example: { "--proxy", "https://proxyserver" }
                install_args = {},
            },
        })
    end,
}

plugin.mapping = function() end

return plugin
