local plugin = {}

plugin.core = {
    --"williamboman/nvim-lsp-installer",
    "williamboman/mason.nvim",
    run = ":MasonUpdate",
    requires = {
        { "neovim/nvim-lspconfig", disable = vim.g.feature_groups.lsp ~= "builtin" },
        { "williamboman/mason-lspconfig.nvim", disable = vim.g.feature_groups.lsp ~= "builtin" },
        --{"brymer-meneses/grammar-guard.nvim", disable = vim.g.feature_groups.lsp ~= "builtin"}, -- FIXIT: when this plugin provide fix feature https://github.com/brymer-meneses/grammar-guard.nvim/issues/11
    },
    setup = function() -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("mason").setup({
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                },
                border = "single",
            },
        })
        require("mason-lspconfig").setup {
            ensure_installed = {

                "lua_ls", -- lua
                "pyright", -- python
                "ltex", -- grammar
                "sqlls", -- sql
                "clangd"
            },
        }
        --require("nvim-lsp-installer").setup({
        --    ensure_installed = {
        --        "lua_ls", -- lua
        --        "pyright", -- python
        --        "ltex", -- grammar
        --        "sqlls", -- sql
        --        "clangd"
        --    },
        --    automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
        --    ui = {
        --        icons = {
        --            server_installed = "✓",
        --            server_pending = "➜",
        --            server_uninstalled = "✗"
        --        }
        --    }
        --})

        local lspconfig = require("lspconfig")
        require('configure.lsp_config.default_setting')
        local util = require("lspconfig.util")

        lspconfig.lua_ls.setup {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { 'vim' }
                    },
                    workspace = { checkThirdParty = false },
                    telemetry = { enable = false },
                }
            }
        }
        lspconfig.pyright.setup {
            root_dir = function(fname)
                return util.root_pattern(".git", "setup.py", "setup.cfg", "pyproject.toml", "requirements.txt")(fname) or util.path.dirname(fname)
            end,
            cmd = { "pyright-langserver", "--stdio" },
            filetypes = { "python" },
            flags = {
                debounce_text_changes = 150,
            },
            settings = {
                python = {
                    analysis = {
                        autoImportCompletions = true,
                        autoSearchPaths = true,
                        diagnosticMode = "openFilesOnly", -- or "workspace"
                        stubPath = "typings", --or ""
                        typeshedPaths = {},
                        useLibraryCodeForTypes = true,
                    },
                    linting = {
                        enabled = false
                    },
                    --pythonPath = "/home/sun/anaconda3/envs/dlkit/bin/python",
                    --venvPath = "/home/sun/anaconda3/envs/dlkit",
                }
            },
            single_file_support = true
        }

        --lspconfig.sqlls.setup{}
        lspconfig.sqlls.setup {}
        lspconfig.clangd.setup {}
        --require("grammar-guard").init()
        --lspconfig.ltex.setup()
        lspconfig.ltex.setup({
            settings = {
                ltex = {
                    enabled = { "latex", "tex", "bib", "markdown", "vimwiki" },
                    language = "en",
                    diagnosticSeverity = "information",
                    setenceCacheSize = 2000,
                    additionalRules = {
                        enablePickyRules = true,
                        motherTongue = "en",
                    },
                    trace = { server = "verbose" },
                    dictionary = {},
                    disabledRules = {
                        ['en'] = {
                            'WHITESPACE_RULE',
                            "DASH_RULE",
                            "EN_QUOTES",
                            "NON_STANDARD_COMMA",
                            "PUNCTUATION_PARAGRAPH_END",
                            "EN_UNPAIRED_BRACKETS",
                            "WORD_CONTAINS_UNDERSCORE",
                            "COMMA_PARENTHESIS_WHITESPACE",
                        }
                    },
                    hiddenFalsePositives = {},
                },
            },
        })
    end,
}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = { "<leader>", "l", "c" },
        action = '<cmd>Mason<cr>',
        short_desc = "Lsp Config",
        silent = false
    })

    mappings.register({
        mode = "n",
        key = { "g", "d" },
        action = '<cmd>lua vim.lsp.buf.definition()<cr>',
        short_desc = "Goto Definition",
        silent = false
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
        action = '<cmd>lua vim.lsp.buf.references()<cr>',
        short_desc = "Goto References",
        silent = false
    })
    mappings.register({
        mode = "n",
        key = { "g", "i" },
        action = '<cmd>lua vim.lsp.buf.implementation()<cr>',
        short_desc = "Goto Implementation",
        silent = false
    })

    mappings.register({
        mode = "n",
        key = { "K" },
        action = '<cmd>lua vim.lsp.buf.hover()<cr>',
        short_desc = "Displays Hover",
        desc = "Displays hover information about the symbol under the cursor in a floating window. Calling the function twice will jump into the floating window.",
        silent = false
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "s", "n" },
        action = '<cmd>lua vim.diagnostic.goto_next()<cr>',
        short_desc = "Prev Diagnostic",
        silent = true,
    })
    mappings.register({
        mode = "n",
        key = { "<C-p>" },
        action = '<cmd>lua vim.diagnostic.goto_prev()<cr>',
        short_desc = "Next Diagnostic",
        silent = false
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "=" },
        action = ":lua vim.lsp.buf.format()<cr>",
        short_desc = "Code Format"
    })


    mappings.register({
        mode = "n",
        key = { "<leader>", "s", "=" },
        action = ":% !npx sql-formatter --config='$HOME/.sea.nvim/sql_format.json'<cr>",
        short_desc = "Sql Format"
    })

    mappings.register({
        mode = "v",
        key = { "<leader>", "s", "=" },
        action = ": !npx sql-formatter --config='$HOME/.sea.nvim/sql_format.json'<cr>",
        short_desc = "Sql Format"
    })

end
return plugin
