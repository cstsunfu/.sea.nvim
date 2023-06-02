local plugin = {}

plugin.core = {
    "vimwiki/vimwiki",
    --ft = { "markdown", "vimwiki" },
    init = function() -- Specifies code to run before this plugin is loaded.
        vim.g.vimwiki_filetypes = {'markdown', 'pandoc'}
        vim.g.vimwiki_map_prefix = '<leader>O'
        vim.g.vimwiki_key_mappings = {
            all_maps = 1,
            global = 0,
            headers = 0,
            text_objs = 0,
            table_format = 0,
            table_mappings = 1,
            lists = 1,
            links = 1,
            html = 1,
            mouse = 0,
        }
        vim.g.tex_conceal = ''
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        vim.cmd("let g:vimwiki_list = [{'path': $HOME.'/org/', 'syntax': 'markdown', 'ext': '.md'}]")
        local global_func = require('util.global')
        global_func.augroup('Vimwiki Map', {
            {
                events = { 'Filetype' },
                targets = { 'vimwiki', 'markdown', 'vimwiki.markdown.pandoc' },
                command = "vnoremap <silent> <leader><cr> :call VVimwiki_create_dir()<cr>"
            },
            {
                events = { 'Filetype' },
                targets = { 'vimwiki', 'markdown', 'vimwiki.markdown.pandoc' },
                command = "vnoremap <silent> <leader><cr> :call VVimwiki_create_dir()<cr>"
            },
            {
                events = { 'Filetype' },
                targets = { 'vimwiki', 'markdown', 'vimwiki.markdown.pandoc' },
                command = 'inoremap <silent><expr><buffer> <cr> pumvisible() ? coc#_select_confirm() : "<C-]><Esc>:VimwikiReturn 1 5<CR>"'
            },
            {
                events = { 'Filetype' },
                targets = { 'vimwiki', 'markdown', 'vimwiki.markdown.pandoc' },
                command = "nnoremap <silent> <leader><cr> :call NVimwiki_create_dir()<cr>"
            },
            {
                events = { 'Filetype' },
                targets = { 'vimwiki', 'markdown', 'vimwiki.markdown.pandoc' },
                command = "inoremap <silent><expr><buffer> <C-j> vimwiki#tbl#kbd_tab()"
            },
            {
                events = { 'Filetype' },
                targets = { 'vimwiki', 'markdown', 'vimwiki.markdown.pandoc' },
                command = "inoremap <silent><expr><buffer> <C-k> vimwiki#tbl#kbd_shift_tab()"
            },
            {
                events = { 'Filetype' },
                targets = { 'vimwiki', 'markdown', 'vimwiki.markdown.pandoc' },
                command = "nnoremap <localleader>tt :VimwikiToggleListItem<cr>"
            },
        })

    end,
}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = { "<leader>", 'O' },
        action = nil,
        short_desc = "Vimwiki"
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", 'o', ';' },
        action = nil,
        short_desc = "Vimwiki Make Note"
    })
end

return plugin
