local plugin = {}

plugin.core = {
    "kyazdani42/nvim-tree.lua",
    as = "nvim-tree",
    on = { "NvimTreeToggle" },
    --requires = {"kyazdani42/nvim-web-devicons"},
    setup = function() -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        --vim.g.nvim_tree_side = 'right'
        vim.g.nvim_tree_auto_ignore_ft = { 'startify', 'dashboard' }
        vim.g.nvim_tree_git_hl = 0
        vim.g.nvim_tree_highlight_opened_files = 3
        vim.g.nvim_tree_root_folder_modifier = ':~'
        --vim.g.nvim_tree_auto_resize = 1
        vim.g.nvim_tree_add_trailing = 1
        vim.g.nvim_tree_group_empty = 1
        vim.g.nvim_tree_icon_padding = ' '
        --vim.g.nvim_tree_update_cwd = 1
        vim.g.nvim_tree_special_files = { ['Makefile'] = 1, ['MAKEFILE'] = 1 }
        vim.g.nvim_tree_show_icons = { git = 1, folders = 1, files = 1, folder_arrows = 1 }

        vim.g.nvim_tree_show_icons = {
            git = 0,
            folders = 1,
            files = 1
        }

        vim.g.nvim_tree_icons = {
            default = '',
            symlink = '',
            hjson = '!',
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

        vim.cmd("highlight NvimTreeFolderIcon guifg=#0077aa")
        -- following options are the default
        require 'nvim-tree'.setup {
            --nvim_tree_hide_dotfiles = 1,
            --nvim_tree_ignore = { '.git', 'node_modules', '.cache', '$XDG_DATA_HOME'},
            --nvim_tree_gitignore = 0,
            --nvim_tree_window_picker_exclude = {
            --filetype = {'packer', 'qf'},
            --buftype = {'terminal'}
            --},
            --nvim_tree_disable_window_picker = 1,
            --nvim_tree_quit_on_open = 1,
            -- disables netrw completely
            disable_netrw = true,
            -- hijack netrw window on startup
            hijack_netrw  = true,
            -- open the tree when running this setup function
            open_on_setup = false,
            -- updates the root directory of the tree on `DirChanged` (when your run `:cd` usually)
            update_cwd    = true,

            view = {
                -- width of the window, can be either a number (columns) or a string in `%`
                width = "20%",
                -- side of the tree, can be one of 'left' | 'right' | 'top' | 'bottom'
                side = 'right',
                signcolumn = "yes",
                mappings = {
                    -- custom only false will merge the list with the default mappings
                    -- if true, it will only use your list to set the mappings
                    custom_only = false,
                    -- list of mappings to set on the tree manually
                    list = {}
                }
            },
            filters = {
                dotfiles = false,
                custom = { "$XDG_DATA_HOME", "__pycache__" },
                exclude = {},
            },
            git = {
                enable = false,
                ignore = false,
            },
            diagnostics = {
                enable = false,
                icons = {
                    hint = " ",
                    info = " ",
                    warning = " ",
                    error = " ",
                }
            }
        }


    end,
}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = { "<leader>", "f", "t" },
        action = ':NvimTreeToggle<cr>',
        short_desc = "File Tree",
        silent = true
    })
    --nnoremap <leader>r :NvimTreeRefresh<CR>
    --nnoremap <leader>n :NvimTreeFindFile<CR>

end

return plugin
