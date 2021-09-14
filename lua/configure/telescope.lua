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
        {
            'nvim-telescope/telescope-project.nvim',
            opt = true,
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
        if not packer_plugins['telescope-project.nvim'].loaded then
            vim.cmd [[packadd telescope-project.nvim]]
        end
        if not packer_plugins['sql.nvim'].loaded then
            vim.cmd [[packadd sql.nvim]]
        end
        local actions = require('telescope.actions')
        require'telescope'.load_extension('project')

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
                },
                project = {
                    base_dirs = {
                        '~/dev/src',
                        {'~/dev/src2'},
                        {'~/dev/src3', max_depth = 4},
                        {path = '~/dev/src4'},
                        {path = '~/dev/src5', max_depth = 2},
                    },
                    hidden_files = true -- default: false
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
        short_desc = "Find Query",
        silent = true
    })
    mappings.register({
        mode = "n",
        key = {"<leader>", "f", "b"},
        action = "<cmd>lua require('telescope.builtin').buffers()<cr>",
        short_desc = "Find Buffers",
        silent = true
    })
    mappings.register({
        mode = "n",
        key = {"<leader>", "f", "w"},
        action = "<cmd>lua require 'telescope.builtin'.find_files{ cwd = vim.g.HOME_PATH .. 'wiki'}<cr>",
        short_desc = "Find Wiki",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = {"<leader>", "f", "j"},
        action = "<cmd>lua require 'telescope.builtin'.find_files{ cwd = vim.g.HOME_PATH .. 'job'}<cr>",
        short_desc = "Find Wiki",
        silent = true
    })
    mappings.register({
        mode = "n",
        key = {"<leader>", "f", "h"},
        action = "<Cmd>lua require('telescope').extensions.frecency.frecency{ sorter = require('telescope.config').values.file_sorter()}<CR>",
        short_desc = "Find Recent/History",
        silent = true,
        noremap = true
    })
    mappings.register({
        mode = "n",
        key = {"<leader>", "f", "p"},
        action = "<Cmd>lua require'telescope'.extensions.project.project{}<CR>",
        short_desc = "Find Recent/History",
        silent = true,
        noremap = true
    })
end
return plugin
