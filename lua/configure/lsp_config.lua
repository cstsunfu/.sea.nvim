local plugin = {}

plugin.core = {
    "williamboman/nvim-lsp-installer",
    requires = {
        "neovim/nvim-lspconfig",
        "brymer-meneses/grammar-guard.nvim", -- for grammar check
    },
    setup = function() -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("nvim-lsp-installer").setup({
            ensure_installed = {
                "sumneko_lua", -- lua
                "pyright", -- python
                "ltex", -- grammar
            },
            automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
            ui = {
                icons = {
                    server_installed = "✓",
                    server_pending = "➜",
                    server_uninstalled = "✗"
                }
            }
        })

        local lspconfig = require("lspconfig")
        local util = require("lspconfig.util")
        lspconfig.sumneko_lua.setup {}
        lspconfig.pyright.setup {
            root_dir = function(fname)
                return util.root_pattern(".git", "setup.py", "setup.cfg", "pyproject.toml", "requirements.txt")(fname) or util.path.dirname(fname)
            end,
            cmd = { "pyright-langserver", "--stdio" },
            filetypes = { "python" },
            --root_dir = function(filename)
            --return util.root_pattern(unpack(root_files))(filename) or util.path.dirname(filename)
            --end,
            settings = {
                python = {
                    analysis = {
                        autoSearchPaths = true,
                        diagnosticMode = "workspace",
                        useLibraryCodeForTypes = true
                    }
                }
            }
        }
    end,
}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = { "g", "d" },
        action = '<cmd>lua vim.lsp.buf.definition()<cr>',
        short_desc = "Goto Definition",
        silent = false
    })
    mappings.register({
        mode = "n",
        key = { "g", "D" },
        action = '<cmd>lua vim.lsp.buf.declaration()<cr>',
        short_desc = "Goto Declaration",
        silent = false
    })
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
        action = '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>',
        short_desc = "Prev Diagnostic",
        silent = true,
    })
    mappings.register({
        mode = "n",
        key = { "<C-p>" },
        action = '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>',
        short_desc = "Next Diagnostic",
        silent = false
    })

end
return plugin
