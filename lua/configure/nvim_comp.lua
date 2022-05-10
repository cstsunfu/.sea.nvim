local plugin = {}

plugin.core = {
    "hrsh7th/nvim-cmp",
    --as = "nvim-compe",
    after = {
        "lspconfig"
    },
    requires = {
        "quangnguyen30192/cmp-nvim-ultisnips", -- ultisnips source
        "hrsh7th/cmp-nvim-lsp", --buildin lsp source
        "hrsh7th/cmp-buffer", --buffer source
        "hrsh7th/cmp-path", --path source
        "hrsh7th/cmp-cmdline", -- for commandline complation
    },
    setup = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        local cmp = require 'cmp'
        cmp.setup({
            snippet = {
                -- REQUIRED - you must specify a snippet engine
                expand = function(args)
                    vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                end,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'ultisnips' }, -- For ultisnips users.
            }, {
                { name = 'buffer' },
            })
        })

        -- Set configuration for specific filetype.
        cmp.setup.filetype('gitcommit', {
            sources = cmp.config.sources({
                { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
            }, {
                { name = 'buffer' },
            })
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
                { name = 'cmdline' }
            })
        })

        -- Setup lspconfig.
        local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

    end
}

plugin.mapping = function()
    --local mappings = require('core.mapping')
    --local is_prior_char_whitespace = function()
    --    local col = vim.fn.col('.') - 1
    --    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    --        return true
    --    else
    --        return false
    --    end
    --end

    ---- Use (shift-)tab to:
    ---- move to prev/next item in completion menu
    ---- jump to the prev/next snippet placeholder
    ---- insert a simple tab
    ---- start the completion menu
    --_G.tab_completion = function()
    --    if vim.fn.pumvisible() == 1 then
    --        return vim.api.nvim_replace_termcodes("<C-n>", true, true, true)

    --    elseif vim.fn["UltiSnips#CanExpandSnippet"]() == 1 or vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
    --        return vim.api.nvim_replace_termcodes("<C-R>=UltiSnips#ExpandSnippetOrJump()<CR>", true, true, true)

    --    elseif is_prior_char_whitespace() then
    --        return vim.api.nvim_replace_termcodes("<Tab>", true, true, true)

    --    else
    --        return vim.fn['compe#complete']()
    --    end
    --end
    --_G.shift_tab_completion = function()
    --    if vim.fn.pumvisible() == 1 then
    --        return vim.api.nvim_replace_termcodes("<C-p>", true, true, true)

    --    elseif vim.fn["UltiSnips#CanJumpBackwards"]() == 1 then
    --        return vim.api.nvim_replace_termcodes("<C-R>=UltiSnips#JumpBackwards()<CR>", true, true, true)

    --    else
    --        return vim.api.nvim_replace_termcodes("<S-Tab>", true, true, true)
    --    end
    --end
    --mappings.register({
    --    mode = "i",
    --    key = { "<Tab>" },
    --    action = 'v:lua.tab_complete()',
    --    short_desc = "complete",
    --    expr = true
    --})
    --mappings.register({
    --    mode = "s",
    --    key = { "<Tab>" },
    --    action = 'v:lua.tab_complete()',
    --    short_desc = "complete",
    --    expr = true
    --})
    --mappings.register({
    --    mode = "i",
    --    key = { "<S-Tab>" },
    --    action = 'v:lua.s_tab_complete()',
    --    short_desc = "complete",
    --    expr = true
    --})
    --mappings.register({
    --    mode = "s",
    --    key = { "<S-Tab>" },
    --    action = 'v:lua.s_tab_complete()',
    --    short_desc = "complete",
    --    expr = true
    --})
end
return plugin
