local plugin = {}

plugin.core = {
    'lukas-reineke/indent-blankline.nvim',
    setup = function()  -- Specifies code to run before this plugin is loaded.
        --let g:indent_blankline_char_list = ['|', '¦', '┆', '┊']
        --vim.g.indent_blankline_char_list = {'│'}

        --vim.g.indent_blankline_filetype_exclude = {'help'}
        --vim.g.indent_blankline_use_treesitter = 'v:true'
        --vim.g.indent_blankline_context_highlight_list = {'Warning'}
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        vim.g.indent_blankline_char_list = {'│'}

        vim.g.indent_blankline_filetype_exclude = {"translator", "dapui_breakpoints", "dapui_watches", "dapui_stacks", "dapui_scopes", "", 'help', 'packer', 'startify', 'dashboard', 'vimwiki', 'markdown'}
        vim.g.indent_blankline_use_treesitter = 'v:true'
        --vim.g.indent_blankline_context_highlight_list = {'Error'}
        vim.cmd('highlight IndentBlanklineChar guifg=#5090c0 gui=nocombine')

        --vim.g.indent_blankline_show_first_indent_level = "v:false"
        --vim.g.indent_blankline_show_trailing_blankline_indent = "v:false"

    end,

}
plugin.mapping = function()

    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = {"z", "R"},
        action = 'zR:IndentBlanklineRefresh<cr>',
        short_desc = "Unzip all",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = {"z", "r"},
        action = 'zr:IndentBlanklineRefresh<cr>',
        short_desc = "Unzip",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = {"z", "a"},
        action = 'za:IndentBlanklineRefresh<cr>',
        short_desc = "Zip toggle",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = {"z", "m"},
        action = 'zm:IndentBlanklineRefresh<cr>',
        short_desc = "Zip current",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = {"z", "M"},
        action = 'zM:IndentBlanklineRefresh<cr>',
        short_desc = "Zip all",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = {"z", "o"},
        action = 'zo:IndentBlanklineRefresh<cr>',
        short_desc = "Unzip current",
        silent = true
    })

end
return plugin
