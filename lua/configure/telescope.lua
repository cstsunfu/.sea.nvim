local plugin = {}

plugin.core = {
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope", "TelescopeFrecencyContent" },
    dependencies = {
        { "nvim-lua/popup.nvim" },
        { "nvim-lua/plenary.nvim" },
        {"tami5/sqlite.lua"},
        { "tami5/sql.nvim" },
        { "nvim-telescope/telescope-file-browser.nvim" },
        {
            "nvim-telescope/telescope-frecency.nvim",
            dependencies = 'telescope.nvim',
        },
        {
            'nvim-telescope/telescope-project.nvim',
            dependencies = 'telescope.nvim',
        },
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make'
        }
    },

    init = function() -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        local actions = require('telescope.actions')
        require 'telescope'.load_extension('project')
        local action_state = require("telescope.actions.state")

        local custom_actions = {}

        function custom_actions.fzf_multi_select(prompt_bufnr)
            local picker = action_state.get_current_picker(prompt_bufnr)
            local num_selections = table.getn(picker:get_multi_selection())

            if num_selections > 1 then
                -- actions.file_edit throws - context of picker seems to change
                --actions.file_edit(prompt_bufnr)
                actions.send_selected_to_qflist(prompt_bufnr)
                actions.open_qflist()
            else
                actions.file_edit(prompt_bufnr)
            end
        end

        -- disalbe large file preview, https://github.com/nvim-telescope/telescope.nvim/issues/623#:~:text=Ignore%20files%20bigger%20than%20a%20threshold.%20Make%20sure%20you%20are%20on%20current%20master%2C%20i%20pushed%20a%20fix%20to%20make%20this%20work%3A
        local previewers = require('telescope.previewers')

        local disable_large_file_previewer_maker = function(filepath, bufnr, opts)
            opts = opts or {}

            filepath = vim.fn.expand(filepath)
            vim.loop.fs_stat(filepath, function(_, stat)
                if not stat then return end
                if stat.size > 10000 then
                    return
                else
                    previewers.buffer_previewer_maker(filepath, bufnr, opts)
                end
            end)
        end

        local previewers_utils = require('telescope.previewers.utils')
        local trunc_large_file_previewer_maker = function(filepath, bufnr, opts)
            opts = opts or {}

            local max_size = 100000
            filepath = vim.fn.expand(filepath)
            vim.loop.fs_stat(filepath, function(_, stat)
                if not stat then return end
                if stat.size > max_size then
                    local cmd = {"head", "-c", max_size, filepath}
                    previewers_utils.job_maker(cmd, bufnr, opts)
                else
                    previewers.buffer_previewer_maker(filepath, bufnr, opts)
                end
            end)
        end

        require('telescope').setup {
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
                prompt_prefix = " ",
                selection_caret = "➤ ",
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
                file_sorter = require 'telescope.sorters'.get_fuzzy_file,
                file_ignore_patterns = {},
                generic_sorter = require 'telescope.sorters'.get_generic_fuzzy_sorter,
                winblend = 0,
                border = {},
                borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
                color_devicons = true,
                use_less = true,
                path_display = {},
                set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
                file_previewer = require 'telescope.previewers'.vim_buffer_cat.new,
                grep_previewer = require 'telescope.previewers'.vim_buffer_vimgrep.new,
                qflist_previewer = require 'telescope.previewers'.vim_buffer_qflist.new,

                -- Developer configurations: Not meant for general override
                -- buffer_previewer_maker = require 'telescope.previewers'.buffer_previewer_maker,
                -- disable preview for large file
                -- buffer_previewer_maker = disable_large_file_previewer_maker,
                -- trunc preview for large file
                buffer_previewer_maker = trunc_large_file_previewer_maker,
                mappings = {
                    i = {
                        ["<esc>"] = actions.close,
                        ["<C-o>"] = custom_actions.fzf_multi_select,
                        ["<C-j>"] = actions.cycle_history_next,
                        ["<C-k>"] = actions.cycle_history_prev,
                    },
                    n = {
                        ["<esc>"] = actions.close,
                        ["<C-o>"] = custom_actions.fzf_multi_select,
                    },
                },
            },
            extensions = {
                frecency = {
                    show_scores = false,
                    show_unindexed = true,
                    ignore_patterns = { "*.git/*" },
                    workspaces = {
                    }
                },
                project = {
                    base_dirs = {
                        '~/.sea.nvim',
                        '~/org',
                        '~/.dotfiles',
                        {'~/workspace', max_depth=4},
                    },
                    hidden_files = true -- default: false
                },
                -- TODO: switch fuzzy and exact, currently use the telescope-fzf-native
                -- https://github.com/nvim-telescope/telescope.nvim/issues/930
                fzf = {
                    fuzzy = true, -- false will only do exact matching
                    override_generic_sorter = true, -- override the generic sorter
                    override_file_sorter = true, -- override the file sorter
                    case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                    -- the default case_mode is "smart_case"
                },
            }
        }
        require 'telescope'.load_extension('fzf')
        require"telescope".load_extension("frecency")
        require("telescope").load_extension "file_browser"
    end,
}

plugin.mapping = function()
    local mappings = require('core.mapping')


    mappings.register({
        mode = "n",
        key = { "<leader>", "f", "f" },
        action = "<cmd>lua require('telescope.builtin').find_files()<cr>",
        short_desc = "Find files",
        silent = true,
    })
    mappings.register({
        mode = "n",
        key = {"<leader>", "f", "B"},
        action = "<cmd>Telescope file_browser<cr>",
        short_desc = "File Browser",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = {"<leader>", "f", "R"},
        action = ":lua _G.plugin_telescope__frecency_content(500)<CR>",
        short_desc = "Find Recent Context",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = {"<leader>", "f", "r"},
        action = "<Cmd>lua require('telescope').extensions.frecency.frecency{ sorter = require('telescope.config').values.file_sorter()}<CR>",
        short_desc = "Find Recent/History",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "f", "q" },
        action = "<cmd>lua require('telescope.builtin').live_grep()<cr>",
        short_desc = "Find Query",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "f", "l" },
        action = "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find({skip_empty_lines=true})<cr>",
        short_desc = "Find Lines",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "f", "b" },
        action = "<cmd>lua require('telescope.builtin').buffers()<cr>",
        short_desc = "Find Buffers",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "f", "c" },
        action = "<cmd>lua require('telescope.builtin').command_history()<cr>",
        short_desc = "Find Command History",
        silent = true,
        noremap = true
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "f", "d" },
        action = "<cmd>lua require 'telescope.builtin'.find_files{ cwd = vim.g.HOME_PATH .. '/.sea.nvim'}<cr>",
        short_desc = 'Open Dotfiles                  ',
        silent = true,
        noremap = true
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "f", "w" },
        action = "<cmd>lua require 'telescope.builtin'.find_files{ cwd = vim.g.HOME_PATH .. '/MyKB'}<cr>",
        short_desc = "Find Obsidian(wiki)",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "f", "j" },
        action = "<cmd>lua require 'telescope.builtin'.find_files{ cwd = vim.g.HOME_PATH .. '/org/work'}<cr>",
        short_desc = "Find Wiki",
        silent = true
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "f", "h" },
        action = "<Cmd>lua require('telescope').extensions.frecency.frecency{ sorter = require('telescope.config').values.file_sorter()}<CR>",
        short_desc = "Find Recent/History",
        silent = true,
        noremap = true
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "f", "p" },
        action = "<Cmd>lua require'telescope'.extensions.project.project{}<CR>",
        short_desc = "Find Project",
        silent = true,
        noremap = true
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "s", "p" },
        action = '<Cmd>lua require("telescope._extensions.project.actions").add_project_cwd()<CR>',
        short_desc = "Save Project",
        silent = true,
        noremap = true
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "f", "m" },
        action = "<cmd>lua require('telescope.builtin').keymaps()<cr>",
        short_desc = "Find All Mappings",
        silent = true,
        noremap = true
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "f", ";" },
        action = nil,
        short_desc = "Find More",
        silent = true,
        noremap = true
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "f", ";", "r" },
        action = "<cmd>lua require('telescope.builtin').registers()<cr>",
        short_desc = "Find Registers",
        silent = true,
        noremap = true
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "f", ";", "h" },
        action = "<cmd>lua require('telescope.builtin').highlights()<cr>",
        short_desc = "Find Highlights",
        silent = true,
        noremap = true
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "f", ";", "t" },
        action = "<cmd>lua require('telescope.builtin').colorscheme()<cr>",
        short_desc = "Find Themes",
        silent = true,
        noremap = true
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "f", ";", "p" },
        action = "<cmd>lua require('telescope.builtin').planets()<cr>",
        short_desc = "Find Planets",
        silent = true,
        noremap = true
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "f", ";", "g" },
        action = "<cmd>lua require('telescope.builtin').git_commits()<cr>",
        short_desc = "Find Git Commits",
        silent = true,
        noremap = true
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "f", ";", "G" },
        action = "<cmd>lua require('telescope.builtin').git_bcommits()<cr>",
        short_desc = "Find Git Commits(buffer)",
        silent = true,
        noremap = true
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "f", ";", "j" },
        action = "<cmd>lua require('telescope.builtin').jumplist()<cr>",
        short_desc = "Find Jump List",
        silent = true,
        noremap = true
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "f", ";", "m" },
        action = "<cmd>lua require('telescope.builtin').marks()<cr>",
        short_desc = "Find Marks",
        silent = true,
        noremap = true
    })

    _G.plugin_telescope__frecency_content = function(top_n)

        local actions = require "telescope.actions"
        local pickers = require "telescope.pickers"
        local make_entry = require "telescope.make_entry"
        local finders = require "telescope.finders"
        local conf = require("telescope.config").values
        local vimgrep_arguments = conf.vimgrep_arguments
        local args = vim.tbl_flatten { vimgrep_arguments }

        local frecency = require("frecency.frecency").new({})
        local frecency_picker = require "frecency.picker".new(frecency.database, frecency.entry_maker, frecency.fs, frecency.recency, {
            default_workspace_tag = frecency.config.default_workspace,
            editing_bufnr = vim.api.nvim_get_current_buf(),
            filter_delimiter = frecency.config.filter_delimiter,
            initial_workspace_tag = nil,
            show_unindexed = frecency.config.show_unindexed,
            workspaces = frecency.config.workspaces,
        })
        local filepath_formatter = frecency_picker.filepath_formatter(frecency_picker, {})
        local entry_maker = frecency_picker.entry_maker:create(filepath_formatter, frecency_picker.workspace,frecency_picker.workspace_tag)
        local need_scandir = not not (frecency_picker.workspace and frecency_picker.config.show_unindexed)
        local find = require "frecency.finder".new(frecency_picker.database, entry_maker, frecency_picker.fs, need_scandir, frecency_picker.workspace, frecency_picker.recency, frecency_picker.state)
        local frecency_file_path = {}
        for _, result in ipairs(find.get_results(find, find.workspace)) do
            table.insert(frecency_file_path, result.path)
        end
        local live_grepper = finders.new_job(function(prompt)
            if not prompt or prompt == "" then
                return nil
            end

            return vim.tbl_flatten { args, "--", prompt, frecency_file_path }
        end, make_entry.gen_from_vimgrep({}), 1000, '/')

        pickers
        .new({}, {
            prompt_title = "Live Grep Frecency",
            finder = live_grepper,
            previewer = conf.grep_previewer({}),
            -- TODO: It would be cool to use `--json` output for this
            -- and then we could get the highlight positions directly.
            sorter = require'telescope.sorters'.highlighter_only({}),
            attach_mappings = function(_, map)
                map("i", "<c-space>", actions.to_fuzzy_refine)
                return true
            end,
        })
        :find()
    end
end
return plugin
