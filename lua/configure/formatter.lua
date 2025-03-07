local plugin = {}

plugin.core = {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    tag = "v9.0.0",
    dependencies = { "williamboman/mason.nvim" },
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        -- Utilities for creating configurations
        -- After add a formatter should update the mason.lua file to install the formatter
        require("conform").setup({
            formatters = {
                sqlformatter_with_config = {
                    command = "sql-formatter",
                    args = { "--config", vim.g.CONFIG .. "/sql-formatter.json" },
                },
                pg_format_with_config = {
                    command = "pg_format",
                    args = {},
                },
            },
            formatters_by_ft = {
                lua = { "stylua" },
                sql = { "sqlformatter_with_config" },
                --sql = { "sqlfmt" },
                --sql = { "pg_format" },
                -- Conform will run multiple formatters sequentially
                python = { "isort", "black" },
                -- Use a sub-list to run only the first available formatter
                --javascript = { { "prettierd", "prettier" } },
                ["*"] = { "codespell" },
                -- Use the "_" filetype to run formatters on filetypes that don't
                -- have other formatters configured.
                ["_"] = { "trim_whitespace" },
            },
            format_on_save = function(bufnr)
                -- Disable autoformat on certain filetypes
                local ignore_filetypes = { "sql", "python.markdown" }
                if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
                    return
                end
                -- Disable with a global or buffer-local variable
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                end
                -- Disable autoformat for files in a certain path
                local bufname = vim.api.nvim_buf_get_name(bufnr)
                if bufname:match("/node_modules/") then
                    return
                end
                if bufname:match("/spu/") then
                    return
                end
                -- ...additional logic...
                return { timeout_ms = 1200, lsp_fallback = true }
            end,
        })

        vim.api.nvim_create_user_command("FormatDisable", function(args)
            if args.bang then
                -- FormatDisable! will disable formatting just for this buffer
                vim.b.disable_autoformat = true
            else
                vim.g.disable_autoformat = true
            end
        end, {
            desc = "Disable autoformat-on-save",
            bang = true,
        })
        vim.api.nvim_create_user_command("FormatEnable", function()
            vim.b.disable_autoformat = false
            vim.g.disable_autoformat = false
        end, {
            desc = "Re-enable autoformat-on-save",
        })
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")

    mappings.register({
        mode = { "v", "x", "n" },
        key = { "<leader>", "=" },
        action = ':lua require("conform").format({ async = true, lsp_fallback = true })<cr>',
        short_desc = "Auto Format",
    })
end

return plugin
