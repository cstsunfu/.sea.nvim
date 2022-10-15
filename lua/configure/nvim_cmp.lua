local plugin = {}

plugin.core = {
    "hrsh7th/nvim-cmp",
    after = {
        "nvim-lspconfig"
    },
    requires = {
        { "quangnguyen30192/cmp-nvim-ultisnips", disable = vim.g.feature_groups.lsp ~= "builtin" }, -- ultisnips source
        { "hrsh7th/cmp-nvim-lsp", disable = vim.g.feature_groups.lsp ~= "builtin" }, --builtin lsp source
        { "hrsh7th/cmp-buffer", disable = vim.g.feature_groups.lsp ~= "builtin" }, --buffer source
        { "hrsh7th/cmp-path", disable = vim.g.feature_groups.lsp ~= "builtin" }, --path source
        { "hrsh7th/cmp-cmdline", disable = vim.g.feature_groups.lsp ~= "builtin" }, -- for commandline complation
        { "dmitmel/cmp-cmdline-history", disable = vim.g.feature_groups.lsp ~= "builtin" }, -- for commandline complation
        { "hrsh7th/cmp-calc", disable = vim.g.feature_groups.lsp ~= "builtin" }, --for calc
        { "hrsh7th/cmp-emoji", disable = vim.g.feature_groups.lsp ~= "builtin" },
        --{ "lukas-reineke/cmp-rg", disable = vim.g.feature_groups.lsp ~= "builtin" },
        { "rcarriga/cmp-dap", disable = vim.g.feature_groups.lsp ~= "builtin" },
        { "hrsh7th/cmp-nvim-lsp-signature-help", disable = vim.g.feature_groups.lsp ~= "builtin" },
    },
    setup = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        local kind_icons = {
            Text = " ",
            Method = "",
            Function = "",
            Constructor = "",
            Field = "",
            Variable = "",
            Class = "ﴯ",
            Interface = "",
            Module = "",
            Property = " ",
            Unit = "",
            Value = "",
            Enum = "",
            Keyword = "",
            Snippet = "",
            Color = "",
            File = "",
            Reference = "",
            Folder = "",
            EnumMember = "",
            Constant = "",
            Struct = "",
            Event = "",
            Operator = "",
            TypeParameter = " "
        }
        local cmp = require 'cmp'
        vim.cmd [[
            highlight CompNormal guibg=None guifg=None

            highlight CompBorder guifg=#ffaa55 guibg=#None
            autocmd! ColorScheme * highlight CompBorder guifg=#ffaa55 guibg=None
            autocmd FileType AerojumpFilter lua require('cmp').setup.buffer { enabled = false }
        ]]
        --highlight CompDocBorder guifg=# guibg=#None
        --autocmd! ColorScheme * highlight CompDocBorder guifg=#ffaa55 guibg=None
        local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")
        cmp.setup({
            snippet = {
                -- REQUIRED - you must specify a snippet engine
                expand = function(args)
                    vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                end,
            },
            window = {
                completion = {
                    border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
                    --winhighlight = 'NormalFloat:NormalFloat,CompBorder:CompBorder',
                    winhighlight = 'NormalFloat:CompNormal,FloatBorder:CompBorder',
                },
                documentation = {
                    border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
                    --winhighlight = 'NormalFloat:CompNormal,FloatBorder:CompDocBorder',
                    winhighlight = 'NormalFloat:CompNormal,FloatBorder:FloatBorder',
                },
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                --['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                ["<C-j>"] = cmp.mapping(
                    function(fallback)
                        cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
                    end,
                    { "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
                ),
                ["<C-k>"] = cmp.mapping(
                    function(fallback)
                        cmp_ultisnips_mappings.jump_backwards(fallback)
                    end,
                    { "i", "s", --[[ "c" (to enable the mapping in command mode) ]] }
                ),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'ultisnips' }, -- For ultisnips users.
                { name = 'calc' },
                { name = 'nvim_lsp_signature_help' },
                { name = 'path' },
                { name = 'buffer' },
                { name = 'emoji', insert = true },
            }),

            formatting = {
                format = function(entry, vim_item)
                    -- Kind icons
                    vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
                    -- Source
                    vim_item.menu = ({
                        buffer = "[Buf]",
                        nvim_lsp = "[LSP]",
                        ultisnips = "[Snip]",
                        nvim_lua = "[Lua]",
                        orgmode = "[Org]",
                        path = "[Path]",
                        dap = "[DAP]",
                        emoji = "[Emoji]",
                        calc = "[CALC]",
                        latex_symbols = "[LaTeX]",
                        cmdline_history = "[History]",
                        cmdline = "[Command]",
                    })[entry.source.name]
                    return vim_item
                end
            },
            enabled = function()
                return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
                    or require("cmp_dap").is_dap_buffer()
            end,
            preselect = true,

        })

        -- Set configuration for specific filetype.
        cmp.setup.filetype('org', {
            sources = cmp.config.sources({
                { name = 'orgmode' },
                { name = 'buffer' },
                { name = 'path' },
                { name = 'calc' },
                { name = 'ultisnips' },
                { name = 'emoji', insert = true }
            })
        })
        cmp.setup.filetype('markdown', {
            sources = cmp.config.sources({
                { name = 'ultisnips' },
                { name = 'buffer' },
                { name = 'path' },
                { name = 'calc' },
                { name = 'emoji', insert = true }
            })
        })
        cmp.setup.filetype('dap-repl', {
            sources = cmp.config.sources({
                { name = 'dap' },
                { name = 'path' },
            })
        })
        cmp.setup.filetype('gitcommit', {
            sources = cmp.config.sources({
                { name = 'cmp_git' },  -- You can specify the `cmp_git` source if you were installed it.
                { name = 'buffer' },
            }
            )
        })

        -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline('/', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' }
            }
        })

        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'path' }
            }, {
                { name = 'cmdline' },
                { name = 'cmdline_history' },
            })
        })

        -- Setup lspconfig.
        local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
        capabilities.textDocument.completion.completionItem.snippetSupport = true

        require('lspconfig')['gopls'].setup {
            capabilities = capabilities
        }
    end
}

plugin.mapping = function()
end
return plugin
