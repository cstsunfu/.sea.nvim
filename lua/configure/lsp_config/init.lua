local plugin = {}

plugin.core = {
    "neovim/nvim-lspconfig",
    build = ":MasonUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "LspInfo", "LspInstall", "LspUninstall" },
    dependencies = {
        "plenary.nvim",
        "williamboman/mason.nvim",
        { "williamboman/mason-lspconfig.nvim", enabled = vim.g.feature_groups.lsp == "builtin" },
        { "hrsh7th/nvim-cmp", enabled = vim.g.feature_groups.lsp == "builtin" },
    },
    init = function() -- Specifies code to run before this plugin is loaded.
    end,
    config = function() -- Specifies code to run after this plugin is loaded
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
        capabilities.textDocument.foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
        }

        local Path = require("plenary.path")
        local global_fun = require("util.global")
        local mason_lspconfig = require("mason-lspconfig")
        local lspconfig = require("lspconfig")
        local configs = require("lspconfig.configs")
        local util = require("lspconfig.util")

        require("mason").setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
                border = "single",
            },
        })

        if not configs.intc_lsp then
            configs.intc_lsp = {
                default_config = {
                    cmd = { "intc-lsp" },
                    filetypes = { "json", "jsonc", "hjson" },
                    root_dir = function(fname)
                        return util.root_pattern(".intc.json", ".intc.jsonc")(fname)
                    end,
                    single_file_support = false,
                },
                docs = {
                    description = [[ intc language server ]],
                },
            }
        end

        local mason_servers = {
            bashls = {
                cmd = { "bash-language-server", "start" },
                filetypes = { "sh" },
                single_file_support = true,
            },
            lua_ls = {
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        workspace = { checkThirdParty = false },
                        telemetry = { enable = false },
                    },
                },
                filetypes = { "lua" },
                autostart = false,
            },
            jsonls = {},
            pyright = {
                -- 你原有的 pyright 配置保持不变...
                autostart = false,
                settings = {
                    python = {
                        analysis = {
                            autoImportCompletions = true,
                            autoSearchPaths = true,
                            diagnosticMode = "openFilesOnly",
                            useLibraryCodeForTypes = true,
                        },
                        linting = { enabled = false },
                    },
                },
            },
            sqlls = {
                cmd = { "sql-language-server", "up", "--method", "stdio" },
                filetypes = { "sql", "mysql" },
                single_file_support = true,
            },
            clangd = {
                -- 你原有的 clangd 配置保持不变...
            },
            ts_ls = {},
        }

        mason_lspconfig.setup({
            ensure_installed = vim.tbl_keys(mason_servers),
        })

        local common_config = {
            capabilities = capabilities,
            on_attach = function(_, _) end,
        }

        for server_name, server_config in pairs(mason_servers) do
            server_config = vim.tbl_deep_extend("force", common_config, server_config)
            lspconfig[server_name].setup(server_config)
        end

        lspconfig.intc_lsp.setup(common_config)

        require("configure.lsp_config.default_setting")
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
    mappings.register({
        mode = "n",
        key = { "<leader>", "l", "c" },
        action = "<cmd>Mason<cr>",
        short_desc = "Lsp Config",
        silent = false,
    })

    mappings.register({
        mode = "n",
        key = { "g", "d" },
        action = "<cmd>lua vim.lsp.buf.definition()<cr>",
        short_desc = "Goto Definition",
        silent = false,
    })
    --mappings.register({
    --    mode = "n",
    --    key = { "g", "D" },
    --    action = '<cmd>lua vim.lsp.buf.declaration()<cr>',
    --    short_desc = "Goto Declaration",
    --    silent = false
    --})
    mappings.register({
        mode = "n",
        key = { "g", "r" },
        action = "<cmd>lua vim.lsp.buf.references()<cr>",
        short_desc = "Goto References",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "g", "i" },
        action = "<cmd>lua vim.lsp.buf.implementation()<cr>",
        short_desc = "Goto Implementation",
        silent = false,
    })

    --mappings.register({
    --    mode = "n",
    --    key = { "K" },
    --    action = '<cmd>lua vim.lsp.buf.hover()<cr>',
    --    short_desc = "Displays Hover",
    --    desc = "Displays hover information about the symbol under the cursor in a floating window. Calling the function twice will jump into the floating window.",
    --    silent = false
    --})
    mappings.register({
        mode = "n",
        key = { "<leader>", "s", "n" },
        action = "<cmd>lua vim.diagnostic.goto_next()<cr>",
        short_desc = "Prev Diagnostic",
        silent = true,
    })
    mappings.register({
        mode = "n",
        key = { "]", "e" },
        action = "<cmd>lua vim.diagnostic.goto_next()<cr>",
        short_desc = "Next Diagnostic",
        silent = true,
    })
    mappings.register({
        mode = "n",
        key = { "[", "e" },
        action = "<cmd>lua vim.diagnostic.goto_prev()<cr>",
        short_desc = "Prev Diagnostic",
        silent = true,
    })
    mappings.register({
        mode = "n",
        key = { "<C-p>" },
        action = "<cmd>lua vim.diagnostic.goto_prev()<cr>",
        short_desc = "Next Diagnostic",
        silent = false,
    })
end
return plugin
