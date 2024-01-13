local plugin = {}

plugin.core = {
    "neoclide/coc.nvim",
    branch = "release",
    event = "BufEnter",
    init = function() -- Specifies code to run before this plugin is loaded.
        --vim.g['coc_global_extensions'] = {"coc-json", "coc-pyright", "coc-ultisnips", "coc-lua", 'coc-format-json', 'coc-dictionary', 'coc-word', 'coc-spell-checker'}
        vim.g["coc_filetype_map"] = {
            hjson = "json",
            vimwiki = "markdown",
        }
        vim.g["coc_global_extensions"] = {
            "coc-json", -- for coc config
            "coc-pyright", -- for python
            "coc-ultisnips", -- for ultisnips
            "coc-sumneko-lua", -- for lua+neovim runtime
            "coc-format-json", -- for json format
            "coc-calc", -- for quick calc
            "coc-vimlsp", -- for vimscript
            "coc-omni", -- for omni source
            "coc-sql", -- for sql
            "coc-ltex", -- for grammar/spell check
            "coc-docker", -- for dockerfile
            "coc-emoji", -- for emoji start with `=`
            "coc-highlight", -- for emoji start with `=`
            --'coc-symbol-line',                           -- TODO: winbar for navigator the code, https://github.com/neovim/neovim/pull/17336
        }
        vim.g.NERDCustomDelimiters = { hjson = { left = "// " }, json = { left = "// " } }
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        --vim.g.coc_config_home = vim.g.CONFIG
        vim.cmd(
            "autocmd FileType python let b:coc_root_patterns = ['.git', '.env', 'venv', '.venv', 'setup.cfg', 'setup.py', 'pyproject.toml', 'pyrightconfig.json']"
        )
        vim.cmd([[
            highlight! DiagnosticSignError guibg=None guifg=#ec5f67 gui=bold
            highlight! DiagnosticSignWarn guibg=None guifg=#FF8800 gui=bold
            highlight! DiagnosticSignInfo guibg=None guifg=#008080 gui=bold
            highlight! DiagnosticSignHint guibg=None guifg=#a9a1e1 gui=bold
            highlight FloatBorder guifg=#7B68EE guibg=#None
            highlight CocBorderHighlight guifg=#7B68EE guibg=#None

        ]])
        --autocmd! ColorScheme * highlight FloatBorder guifg=#7B68EE guibg=None
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")

    --vim.g.UltiSnipsExpandTrigger = "<leader><tab>" -- confilict
    vim.api.nvim_set_keymap(
        "i",
        "<cr>",
        "pumvisible () ? coc#_select_confirm() : '<C-g>u<cr><C-r>=coc#on_enter()<CR>'",
        { expr = true, silent = true }
    )
    vim.api.nvim_set_keymap("i", "<C-o>", "coc#refresh()", { expr = true, silent = true })
    vim.api.nvim_set_keymap(
        "i",
        "<C-f>",
        "coc#float#has_scroll() ? '<C-r>=coc#float#scroll(1)<CR>':'<Right>'",
        { expr = true, silent = true }
    )
    vim.api.nvim_set_keymap(
        "i",
        "<C-b>",
        "coc#float#has_scroll() ? '<C-r>=coc#float#scroll(0)<CR>':'<Left>'",
        { expr = true, silent = true }
    )
    -- use tab to confirm
    vim.api.nvim_set_keymap(
        "i",
        "<TAB>",
        "pumvisible() ? '\\<C-n>':'\\<tab>'",
        { expr = true, silent = true, noremap = true }
    )
    vim.api.nvim_set_keymap(
        "i",
        "<S-TAB>",
        "pumvisible() ? '\\<C-p>':'\\<c-h>'",
        { expr = true, silent = true, noremap = true }
    )

    mappings.register({
        mode = "n",
        key = { "g", "d" },
        action = "<Plug>(coc-definition)",
        short_desc = "Goto Definition",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "g", "D" },
        action = "<Plug>(coc-declaration)",
        short_desc = "Goto Declaration",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "g", "r" },
        action = "<Plug>(coc-references)",
        short_desc = "Goto References",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "g", "i" },
        action = "<Plug>(coc-implementation)",
        short_desc = "Goto Implementation",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "r", "n" },
        action = "<Plug>(coc-rename)",
        short_desc = "Refactor Name",
        silent = false,
    })

    mappings.register({
        mode = "n",
        key = { "K" },
        action = ':call CocAction("doHover")<CR>',
        short_desc = "Displays Hover",
        silent = true,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "q", "f" },
        action = "<Plug>(coc-fix-current)",
        short_desc = "Quick Fix Error",
        silent = true,
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "s", "p" },
        action = "<Plug>(coc-diagnostic-prev)",
        short_desc = "Prev Diagnostic",
        silent = true,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "s", "n" },
        action = "<Plug>(coc-diagnostic-next)",
        short_desc = "Next Diagnostic",
        silent = true,
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "=" },
        action = ":call CocAction('format')",
        short_desc = "Do Format",
        silent = true,
    })
    mappings.register({
        mode = "v",
        key = { "<leader>", "=" },
        action = ":'<,'>call CocAction('formatSelected')<cr>",
        short_desc = "Do Format Selected",
        silent = true,
    })
end
return plugin
