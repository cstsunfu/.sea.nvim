local plugin = {}

plugin.core = {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        -- Utilities for creating configurations
        require("mason-tool-installer").setup({
            -- a list of all tools you want to ensure are installed upon
            -- start; they should be the names Mason uses for each tool
            ensure_installed = {
                -- you can pin a tool to a particular version
                { "golangci-lint", version = "v1.47.0" },
                -- you can turn off/on auto_update per tool
                { "stylua", auto_update = false },
                "codespell",
                "sql-formatter",
                "sqlfmt",
                "prettierd",
                "isort",
                "black",
            },

            auto_update = false,

            -- :MasonToolsUpdate to install tools and check for updates.
            -- Default: true
            run_on_start = true,
            -- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
            -- Default: 0
            start_delay = 3000, -- 3 second delay

            debounce_hours = 5, -- at least 5 hours between attempts to install/update
        })
        vim.api.nvim_create_autocmd("User", {
            pattern = "MasonToolsStartingInstall",
            callback = function()
                vim.schedule(function()
                    print("mason-tool-installer is starting")
                end)
            end,
        })
        vim.api.nvim_create_autocmd("User", {
            pattern = "MasonToolsUpdateCompleted",
            callback = function(e)
                vim.schedule(function()
                    print(vim.inspect(e.data)) -- print the table that lists the programs that were installed
                end)
            end,
        })
    end,
}

plugin.mapping = function() end

return plugin
