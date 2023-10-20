local plugin = {}

plugin.core = {
    "stevearc/conform.nvim",
    dependencies = { "williamboman/mason.nvim" },
    init = function() -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        -- Utilities for creating configurations
        -- After add a formatter should update the mason.lua file to install the formatter
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                -- Conform will run multiple formatters sequentially
                python = { "isort", "black" },
                -- Use a sub-list to run only the first available formatter
                javascript = { { "prettierd", "prettier" } },
                ["*"] = { "codespell" },
                -- Use the "_" filetype to run formatters on filetypes that don't
                -- have other formatters configured.
                ["_"] = { "trim_whitespace" },
            },
        })
    end,
}

plugin.mapping = function()

    local mappings = require('core.mapping')

    mappings.register({
        mode = {"v", 'x', 'n'},
        key = { '<leader>', '=' },
        action = ':lua require("conform").format({ async = true, lsp_fallback = true })<cr>',
        short_desc = "Auto Format"
    })
end

return plugin
