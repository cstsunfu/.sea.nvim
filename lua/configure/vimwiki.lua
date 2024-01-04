local plugin = {}

plugin.core = {
    "vimwiki/vimwiki",
    init = function() -- Specifies code to run before this plugin is loaded.
        vim.g.vimwiki_filetypes = { "markdown" }
        vim.g.vimwiki_map_prefix = "<leader>O"
        vim.g.vimwiki_key_mappings = {
            all_maps = 1,
            global = 1,
            headers = 0,
            text_objs = 0,
            table_format = 0,
            table_mappings = 1,
            lists = 1,
            links = 0,
            html = 0,
            mouse = 0,
        }
        vim.g.tex_conceal = ""
        vim.g.vimwiki_global_ext = 0
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        --vim.cmd("let g:vimwiki_list = [{'path': '*', 'ext': '.md', 'listsyms': ' ox'}]")
        vim.cmd("let g:vimwiki_list = [{'path': $HOME, 'syntax': 'markdown', 'ext': '.md', 'listsyms': ' ox'}]")
        local global_func = require("util.global")
        global_func.augroup("Vimwiki Map", {
            {
                events = { "Filetype" },
                targets = { "markdown", "vimwiki" },
                command = "vnoremap <buffer><silent> <leader><cr> :call VVimwiki_create_dir()<cr>",
            },
            {
                events = { "Filetype" },
                targets = { "markdown", "vimwiki" },
                command = "vnoremap <buffer><silent> <leader><cr> :call VVimwiki_create_dir()<cr>",
            },
            {
                events = { "Filetype" },
                targets = { "markdown", "vimwiki" },
                command = "nnoremap <buffer><silent> <leader><cr> :call NVimwiki_create_dir()<cr>",
            },
            {
                events = { "Filetype" },
                targets = { "markdown", "vimwiki" },
                command = "inoremap <silent><expr><buffer> <C-j> vimwiki#tbl#kbd_tab()",
            },
            {
                events = { "Filetype" },
                targets = { "markdown", "vimwiki" },
                command = "inoremap <silent><expr><buffer> <C-k> vimwiki#tbl#kbd_shift_tab()",
            },
        })
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
    mappings.register({
        mode = "n",
        key = { "<leader>", "O" },
        action = nil,
        short_desc = "Vimwiki",
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "o", ";" },
        action = nil,
        short_desc = "Vimwiki Make Note",
    })
end

return plugin
