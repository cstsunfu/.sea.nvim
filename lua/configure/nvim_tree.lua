local plugin = {}

plugin.core = {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeClose" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        vim.cmd("highlight NvimTreeFolderIcon guifg=#0077aa")
        -- following options are the default
        require("nvim-tree").setup({
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
                side = "right",
                signcolumn = "yes",
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
                },
            },
        })
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
    _G.toggle_nvim_tree_smart = function()
        local ai_win_id = _G.navigate_avante_window()
        local is_avante_open = ai_win_id.input or ai_win_id.output or ai_win_id.file

        local nvim_tree_view = require("nvim-tree.view")
        local nvim_tree_api = require("nvim-tree.api")

        local curr_win = vim.api.nvim_get_current_win()
        local curr_buf = vim.api.nvim_get_current_buf()
        local curr_ft = vim.api.nvim_get_option_value("filetype", { buf = curr_buf })

        local is_curr_avante = curr_ft == "Avante" or curr_ft == "AvanteInput" or curr_ft == "AvanteSelectedFiles"
        local is_curr_tree = curr_ft == "NvimTree"

        if is_curr_avante or is_curr_tree then
            local wins = vim.api.nvim_tabpage_list_wins(0)
            local safe_win = nil
            for _, win in ipairs(wins) do
                local b = vim.api.nvim_win_get_buf(win)
                local ft = vim.api.nvim_get_option_value("filetype", { buf = b })
                if ft ~= "NvimTree" and not string.find(ft, "Avante") and ft ~= "qf" then
                    safe_win = win
                    break
                end
            end

            if safe_win then
                vim.api.nvim_set_current_win(safe_win)
            else
                return
            end
        end

        if is_avante_open then
            nvim_tree_view.View.side = "left"
        else
            nvim_tree_view.View.side = "right"
        end

        if nvim_tree_api.tree.is_visible() then
            nvim_tree_api.tree.close()
        else
            nvim_tree_api.tree.open()
        end
    end
    mappings.register({
        mode = "n",
        key = { "<leader>", "f", "t" },
        action = ":lua toggle_nvim_tree_smart()<cr>",
        --action = ':lua require"nvim-tree".toggle(false, true)<cr>',
        short_desc = "File Tree",
        silent = true,
    })

    _G.toggle_current_file_tree = function()
        local cwd = vim.fn.getcwd()
        vim.cmd("NvimTreeClose")
        vim.cmd("NvimTreeOpen " .. cwd)
    end

    mappings.register({
        mode = "n",
        key = { "<leader>", "f", "." },
        --action = ":NvimTreeClose<cr>:botright vnew %:~:h<cr>",
        action = ":lua _G.toggle_current_file_tree()<cr>",
        short_desc = "Current File Tree",
        silent = true,
    })
end

return plugin
