local plugin = {}

plugin.core = {
    'neovim/nvim-lspconfig',
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        --require('lspconfig').pyright.setup{}
        --require'lspconfig'.tailwindcss.setup{}
        --require'lspconfig'.zeta_note.setup{
            --cmd = {'/home/sun/zeta-note-linux'}
        --}
    end,
}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = {"<leader>", "g", "d"},
        action = '<cmd>lua vim.lsp.buf.definition()<cr>',
        short_desc = "goto definition",
        silent = true
    })
    mappings.register({
        mode = "n",
        key = {"<leader>", "g", "D"},
        action = '<cmd>lua vim.lsp.buf.declaration()<cr>',
        short_desc = "goto declaration",
        silent = true
    })
    mappings.register({
        mode = "n",
        key = {"<leader>", "g", "r"},
        action = '<cmd>lua vim.lsp.buf.references()<cr>',
        short_desc = "goto references",
        silent = true
    })
    mappings.register({
        mode = "n",
        key = {"<leader>", "g", "i"},
        action = '<cmd>lua vim.lsp.buf.implementation()<cr>',
        short_desc = "goto implementation",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = {"K"},
        action = '<cmd>lua vim.lsp.buf.hover()<cr>',
        short_desc = "Displays hover information about the symbol.",
        desc = "Displays hover information about the symbol under the cursor in a floating window. Calling the function twice will jump into the floating window.",
        silent = true
    })
    mappings.register({
        mode = "n",
        key = {"<C-n>"},
        action = '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>',
        short_desc = "goto prev",
        silent = true
    })
    mappings.register({
        mode = "n",
        key = {"<C-p>"},
        action = '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>',
        short_desc = "goto next",
        silent = true
    })

end
return plugin
