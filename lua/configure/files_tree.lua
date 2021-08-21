local plugin = {}

plugin.core = {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        vim.g.nvim_tree_side = 'right' 
        --vim.g.nvim_tree_width = 40 
        vim.g.nvim_tree_ignore = { '.git', 'node_modules', '.cache' } 
        vim.g.nvim_tree_gitignore = 1 
        vim.g.nvim_tree_auto_open = 0 
        vim.g.nvim_tree_auto_close = 1 
        vim.g.nvim_tree_auto_ignore_ft = { 'startify', 'dashboard' } 
        vim.g.nvim_tree_quit_on_open = 1 
        vim.g.nvim_tree_follow = 1 
        vim.g.nvim_tree_indent_markers = 1 
        vim.g.nvim_tree_hide_dotfiles = 1 
        vim.g.nvim_tree_git_hl = 1 
        vim.g.nvim_tree_highlight_opened_files = 1 
        vim.g.nvim_tree_root_folder_modifier = ':~' 
        vim.g.nvim_tree_tab_open = 1 
        vim.g.nvim_tree_auto_resize = 1 
        vim.g.nvim_tree_disable_netrw = 0 
        vim.g.nvim_tree_hijack_netrw = 0 
        vim.g.nvim_tree_add_trailing = 1 
        vim.g.nvim_tree_group_empty = 1 
        vim.g.nvim_tree_lsp_diagnostics = 1 
        vim.g.nvim_tree_disable_window_picker = 1 
        vim.g.nvim_tree_hijack_cursor = 0 
        vim.g.nvim_tree_icon_padding = ' ' 
        vim.g.nvim_tree_update_cwd = 1 
        vim.g.nvim_tree_window_picker_exclude = {
            filetype = {'packer', 'qf'},
            buftype = {'terminal'}
        }
        vim.g.nvim_tree_special_files = { ['README.md'] = 1, ['Makefile'] = 1, ['MAKEFILE'] = 1 } 
        vim.g.nvim_tree_show_icons = { git = 1, folders = 1, files = 1, folder_arrows = 1}
        
        vim.g.nvim_tree_icons = {
            default = '',
            symlink = '',
            git = {
                unstaged = "✗",
                staged = "✓",
                unmerged = "",
                renamed = "➜",
                untracked = "★",
                deleted = "",
                ignored = "◌"
            },
            folder = {
                arrow_open = "",
                arrow_closed = "",
                default = "",
                open = "",
                empty = "",
                empty_open = "",
                symlink = "",
                symlink_open = "",
            },
            lsp = {
                hint = "",
                info = "",
                warning = "",
                ['error'] = "",
            }
        } 

        vim.cmd("highlight NvimTreeFolderIcon guibg=blue")


    end,
}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = {"<leader>", "f", "t"},
        action = ':NvimTreeToggle<cr>',
        short_desc = "Tag List",
        silent = true
    })
    --nnoremap <leader>r :NvimTreeRefresh<CR>
    --nnoremap <leader>n :NvimTreeFindFile<CR>

end

return plugin
