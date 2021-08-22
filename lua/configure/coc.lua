local plugin = {}

plugin.core = {
    'neoclide/coc.nvim',
    branch = 'release',
    setup = function()  -- Specifies code to run before this plugin is loaded.
        vim.g['coc_global_extensions'] = {"coc-json", "coc-pyright", "coc-ultisnips", "coc-ultisnips", "coc-lua"}
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

    vim.g.UltiSnipsExpandTrigger="<leader><tab>"   -- confilict
    vim.api.nvim_set_keymap("i", "<cr>", "pumvisible () ? coc#_select_confirm() : '<C-g>u<cr><C-r>=coc#on_enter()<CR>'", {expr=true, silent=true})
    vim.api.nvim_set_keymap("i", "<C-o>", "coc#refresh()", {expr=true, silent=true})
    -- use tab to confirm
    vim.api.nvim_set_keymap("i", "<TAB>", "pumvisible() ? '\\<C-n>':'\\<tab>'", {expr=true, silent=true, noremap=true})
    vim.api.nvim_set_keymap("i", "<S-TAB>", "pumvisible() ? '\\<C-p>':'\\<c-h>'", {expr=true, silent=true, noremap=true})

    mappings.register({
        mode = "n",
        key = {"<leader>", "g", "d"},
        action = '<Plug>(coc-definition)',
        short_desc = "goto definition",
        silent = false
    })
    mappings.register({
        mode = "n",
        key = {"<leader>", "g", "D"},
        action = '<Plug>(coc-declaration)',
        short_desc = "goto declaration",
        silent = false
    })
    mappings.register({
        mode = "n",
        key = {"<leader>", "g", "r"},
        action = '<Plug>(coc-references)',
        short_desc = "goto references",
        silent = false
    })
    mappings.register({
        mode = "n",
        key = {"<leader>", "g", "i"},
        action = '<Plug>(coc-implementation)',
        short_desc = "goto implementation",
        silent = false
    })

    mappings.register({
        mode = "n",
        key = {"K"},
        action = ':call <SID>show_documentation()<CR>',
        short_desc = "Displays hover information about the symbol.",
        silent = true
    })
    mappings.register({
        mode = "n",
        key = {"<leader>", 'q', 'f'},
        action = '<Plug>(coc-fix-current)',
        short_desc = "Quick fix the errors.",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = {"<leader>", "s", "p"},
        action = "<Plug>(coc-diagnostic-prev)",
        short_desc = "goto prev diagnostic",
        silent = true
    })
    mappings.register({
        mode = "n",
        key = {"<leader>", "s", "n"},
        action = "<Plug>(coc-diagnostic-next)",
        short_desc = "goto next diagnostic",
        silent = true,
    })
end
return plugin

