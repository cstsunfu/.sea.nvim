local plugin = {}

plugin.core = {
    'nvim-telescope/telescope.nvim',
    --requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
    requires = {
        'nvim-lua/popup.nvim',
        {'nvim-lua/plenary.nvim', opt=true},
        {
            'nvim-telescope/telescope-frecency.nvim',
            opt = true,
            requires = {'tami5/sql.nvim', opt=true},
            after = 'telescope.nvim',
        },
    },

    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        if not packer_plugins['popup.nvim'].loaded then
            vim.cmd [[packadd popup.nvim]]
        end
        if not packer_plugins['plenary.nvim'].loaded then
            vim.cmd [[packadd plenary.nvim]]
        end
        if not packer_plugins['telescope-frecency.nvim'].loaded then
            vim.cmd [[packadd telescope-frecency.nvim]]
        end
        if not packer_plugins['sql.nvim'].loaded then
            vim.cmd [[packadd sql.nvim]]
        end
        local actions = require('telescope.actions')

        require('telescope').setup{
            defaults = {
                vimgrep_arguments = {
                    'rg',
                    '--color=never',
                    '--no-heading',
                    '--with-filename',
                    '--line-number',
                    '--column',
                    '--smart-case'
                },
                prompt_prefix = "> ",
                selection_caret = "> ",
                entry_prefix = "  ",
                initial_mode = "insert",
                selection_strategy = "reset",
                sorting_strategy = "descending",
                layout_strategy = "horizontal",
                history = {
                    path = '~/.local/share/nvim/telescope_history.sqlite3',
                },
                layout_config = {
                    horizontal = {
                        mirror = false,
                    },
                    vertical = {
                        mirror = false,
                    },
                },
                file_sorter =  require'telescope.sorters'.get_fuzzy_file,
                file_ignore_patterns = {},
                generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
                winblend = 0,
                border = {},
                borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
                color_devicons = true,
                use_less = true,
                path_display = {},
                set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
                file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
                grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
                qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

                -- Developer configurations: Not meant for general override
                buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker,
                mappings = {
                    i = {
                        ["<esc>"] = actions.close,
                        ["<C-j>"] = actions.cycle_history_next,
                        ["<C-k>"] = actions.cycle_history_prev,
                    },
                    --n = {
                        --["<esc>"] = actions.close,
                    --},
                },
            },
            extensions = {
                frecency = {
                    show_scores = false,
                    show_unindexed = false,
                    ignore_patterns = {"*.git/*", "*/tmp/*"},
                    workspaces = {
                        ["conf"] = vim.g.HOME_PATH.. ".config",
                        ["data"] = vim.g.HOME_PATH.. ".local/share",
                        ["nvim"] = vim.g.HOME_PATH.. ".config/nvim",
                        ["work"] = vim.g.HOME_PATH.. "workspaces",
                    }
                }
            }
        }
    end,
}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = {"<leader>", "f", "f"},
        action = "<cmd>lua require('telescope.builtin').find_files()<cr>",
        short_desc = "Find files",
        silent = true,
    })

    mappings.register({
        mode = "n",
        key = {"<leader>", "f", "q"},
        action = "<cmd>lua require('telescope.builtin').live_grep()<cr>",
        short_desc = "Find query",
        silent = true
    })
    mappings.register({
        mode = "n",
        key = {"<leader>", "f", "b"},
        action = "<cmd>lua require('telescope.builtin').buffers()<cr>",
        short_desc = "Find buffers",
        silent = true
    })
    mappings.register({
        mode = "n",
        key = {"<leader>", "f", "h"},
        action = "<cmd>lua require('telescope.builtin').buffers()<cr>",
        short_desc = "Find tags",
        silent = true
    })
    mappings.register({
        mode = "n",
        key = {"<leader>", "f", "r"},
        action = "<Cmd>lua require('telescope').extensions.frecency.frecency{ sorter = require('telescope.config').values.file_sorter()}<CR>",
        short_desc = "Find recent/history",
        silent = true,
        noremap = true
    })
end
return plugin
