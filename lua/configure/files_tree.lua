local plugin = {}

plugin.core = {
    "kyazdani42/nvim-tree.lua",
    as = "nvim-tree",
    requires = {"kyazdani42/nvim-web-devicons"},
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        --vim.g.nvim_tree_side = 'right'
        vim.g.nvim_tree_ignore = { '.git', 'node_modules', '.cache' }
        vim.g.nvim_tree_gitignore = 1
        vim.g.nvim_tree_auto_ignore_ft = { 'startify', 'dashboard' }
        vim.g.nvim_tree_quit_on_open = 1
        vim.g.nvim_tree_indent_markers = 1
        vim.g.nvim_tree_hide_dotfiles = 1
        vim.g.nvim_tree_git_hl = 0
        vim.g.nvim_tree_highlight_opened_files = 1
        vim.g.nvim_tree_root_folder_modifier = ':~'
        --vim.g.nvim_tree_auto_resize = 1
        vim.g.nvim_tree_add_trailing = 1
        vim.g.nvim_tree_group_empty = 1
        vim.g.nvim_tree_disable_window_picker = 1
        vim.g.nvim_tree_icon_padding = ' '
        --vim.g.nvim_tree_update_cwd = 1
        vim.g.nvim_tree_window_picker_exclude = {
            filetype = {'packer', 'qf'},
            buftype = {'terminal'}
        }
        vim.g.nvim_tree_special_files = { ['README.md'] = 1, ['Makefile'] = 1, ['MAKEFILE'] = 1 }
        vim.g.nvim_tree_show_icons = { git = 1, folders = 1, files = 1, folder_arrows = 1}

        vim.g.nvim_tree_show_icons = {
            git = 0,
            folders = 1,
            files = 1
        }

        vim.g.nvim_tree_icons = {
            default = '',
            symlink = '',
            --git = {
                --unstaged = "",
                --staged = "",
                --unmerged = "",
                --renamed = "",
                --untracked = "",
                --deleted = "",
                --ignored = ""
            --},
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
            --lsp = {
                --hint = "",
                --info = "",
                --warning = "",
                --['error'] = "",
            --}
        }

        vim.cmd("highlight NvimTreeFolderIcon guibg=blue")
        -- following options are the default
        require'nvim-tree'.setup {
            -- disables netrw completely
            disable_netrw       = true,
            -- hijack netrw window on startup
            hijack_netrw        = true,
            -- open the tree when running this setup function
            open_on_setup       = false,
            -- will not open on setup if the filetype is in this list
            ignore_ft_on_setup  = {},
            -- closes neovim automatically when the tree is the last **WINDOW** in the view
            auto_close          = false,
            -- opens the tree when changing/opening a new tab if the tree wasn't previously opened
            open_on_tab         = false,
            -- hijack the cursor in the tree to put it at the start of the filename
            hijack_cursor       = false,
            -- updates the root directory of the tree on `DirChanged` (when your run `:cd` usually) 
            update_cwd          = false,
            -- update the focused file on `BufEnter`, un-collapses the folders recursively until it finds the file
            update_focused_file = {
                -- enables the feature
                enable      = false,
                -- update the root directory of the tree to the one of the folder containing the file if the file is not under the current root directory
                -- only relevant when `update_focused_file.enable` is true
                update_cwd  = false,
                -- list of buffer names / filetypes that will not update the cwd if the file isn't found under the current root directory
                -- only relevant when `update_focused_file.update_cwd` is true and `update_focused_file.enable` is true
                ignore_list = {}
            },
            -- configuration options for the system open command (`s` in the tree by default)
            system_open = {
                -- the command to run this, leaving nil should work in most cases
                cmd  = nil,
                -- the command arguments as a list
                args = {}
            },

            view = {
                -- width of the window, can be either a number (columns) or a string in `%`
                width = "16%",
                -- side of the tree, can be one of 'left' | 'right' | 'top' | 'bottom'
                side = 'right',
                -- if true the tree will resize itself after opening a file
                auto_resize = false,
                mappings = {
                    -- custom only false will merge the list with the default mappings
                    -- if true, it will only use your list to set the mappings
                    custom_only = false,
                    -- list of mappings to set on the tree manually
                    list = {}
                }
            },
            diagnostics = {
                enable = false,
                icons = {
                    hint = "",
                    info = "",
                    warning = "",
                    error = "",
                }
            }
        }


    end,
}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = {"<leader>", "f", "t"},
        action = ':NvimTreeToggle<cr>',
        short_desc = "File Tree",
        silent = true
    })
    --nnoremap <leader>r :NvimTreeRefresh<CR>
    --nnoremap <leader>n :NvimTreeFindFile<CR>

end

return plugin
