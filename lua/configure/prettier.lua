local plugin = {}

plugin.core = {
    "MunifTanjim/prettier.nvim",
    event = "VeryLazy",
    dependencies = {
        { "neovim/nvim-lspconfig", enabled = vim.g.feature_groups.lsp == "builtin" },
        { "jose-elias-alvarez/null-ls.nvim", enabled = vim.g.feature_groups.lsp == "builtin" },
    },
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        -- Utilities for creating configurations
        local null_ls = require("null-ls")

        local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
        local event = "BufWritePre" -- or "BufWritePost"
        local async = event == "BufWritePost"

        null_ls.setup({
            on_attach = function(client, bufnr)
                if client.supports_method("textDocument/formatting") then
                    vim.keymap.set("n", "<Leader>=", function()
                        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
                    end, { buffer = bufnr, desc = "[lsp] format" })

                    ---- format on save
                    --vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
                    --vim.api.nvim_create_autocmd(event, {
                    --    buffer = bufnr,
                    --    group = group,
                    --    callback = function()
                    --        vim.lsp.buf.format({ bufnr = bufnr, async = async })
                    --    end,
                    --    desc = "[lsp] format on save",
                    --})
                end

                if client.supports_method("textDocument/rangeFormatting") then
                    vim.keymap.set("x", "<Leader>=", function()
                        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
                    end, { buffer = bufnr, desc = "[lsp] format" })
                end
            end,
        })

        -- setup prettier
        local prettier = require("prettier")

        prettier.setup({
            bin = "prettier", -- or `'prettierd'` (v0.23.3+)
            filetypes = {
                "css",
                "graphql",
                "html",
                "javascript",
                "json",
                "markdown",
                "typescript",
                "yaml",
                "python",
                "lua",
                "sql",
            },
        })
    end,
}

plugin.mapping = function() end

return plugin
