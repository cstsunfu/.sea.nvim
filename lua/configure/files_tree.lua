local plugin = {}

plugin.core = {
    "nvim-tree/nvim-tree.lua",
    on = { "NvimTreeToggle" },
    dependencies = {"nvim-tree/nvim-web-devicons"},
    init = function() -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded

        vim.cmd("highlight NvimTreeFolderIcon guifg=#0077aa")
        -- following options are the default
        require 'nvim-tree'.setup {
            disable_netrw = true,
            --ignore_ft_on_    init = { 'startify', 'dashboard' },
            renderer = {
                add_trailing = false,
                group_empty = false,
                highlight_git = false,
                highlight_opened_files = "none", -- Value can be `"none"`, `"icon"`, `"name"` or `"all"`.
                root_folder_modifier = ":~",
                indent_markers = {
                    enable = true,
                    icons = {
                        corner = "└ ",
                        edge = "│ ",
                        none = "  ",
                    },
                },
                icons = {
                    webdev_colors = true,
                    git_placement = "before",
                    padding = " ",
                    symlink_arrow = " ➛ ",
                    show = {
                        file = true,
                        folder = true,
                        folder_arrow = true,
                        git = true,
                    },
                    glyphs = {
                        default = "",
                        symlink = "",
                        folder = {
                            arrow_closed = "",
                            arrow_open = "",
                            default = "",
                            open = "",
                            empty = "",
                            empty_open = "",
                            symlink = "",
                            symlink_open = "",
                        },
                        git = {
                            unstaged = "✗",
                            staged = "✓",
                            unmerged = "",
                            renamed = "➜",
                            untracked = "★",
                            deleted = "",
                            ignored = "◌",
                        },
                    },
                },
                special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md", "MAKEFILE" },
            },

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
        --action = ':lua require"nvim-tree".toggle(false, true)<cr>',
        short_desc = "File Tree",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "f", "." },
        --action = ':NvimTreeToggle<cr>',
        action = ':NvimTreeClose<cr>:botright vnew %:~:h<cr>',
        short_desc = "Current File Tree",
        silent = true
    })

end

return plugin
