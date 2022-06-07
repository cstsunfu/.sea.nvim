local plugin = {}

plugin.core = {
    "glepnir/dashboard-nvim",
    --as = "dashboard-nvim",

    setup = function()  -- Specifies code to run before this plugin is loaded.
        vim.g.dashboard_default_executive = 'telescope'
        vim.g.dashboard_preview_command = 'cat'
        vim.g.dashboard_preview_pipeline = 'lolcat'
        vim.g.dashboard_preview_file_height = 10
        vim.g.dashboard_preview_file_width = 70
        vim.g.dashboard_preview_file = vim.g.CONFIG..'/lua/util/neovim.txt'
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        vim.g.dashboard_custom_footer = {"💎 Have A Good Day! "}
        vim.g.dashboard_custom_shortcut = {
            find_history       = '<leader> f h',
            new_file           = '<leader> c f',    -- FIXME: https://github.com/glepnir/dashboard-nvim/issues/79
            find_file          = '<leader> f f',
            change_colorscheme = '<leader> f C',
            find_word          = '<leader> f q',
            book_marks         = '<leader> f m',
            last_session       = '<leader> s l',
        }
        vim.g.dashboard_session_directory = vim.fn.stdpath('cache').."/session"
    end,
}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = {"<leader>", "s", "k"},
        action = ':<C-u>SessionSave<cr>',
        short_desc = "Session Keep",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = {"<leader>", "s", "l"},
        action = ':<C-u>SessionLoad<cr>',
        short_desc = "Last Session",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = {"<leader>", "s", "L"},
        action = ':SessionLoad ',
        short_desc = "Session List",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = {"<leader>", "f", "r"},
        --action = ':DashboardFindHistory<CR>',
        --short_desc = "Find History By Dashboard",
        action = "<Cmd>lua require('telescope').extensions.frecency.frecency{ sorter = require('telescope.config').values.file_sorter()}<CR>",
        short_desc = "Find Recent/History",
        silent = true
    })
    mappings.register({
        mode = "n",
        key = {"<leader>", "f", "C"},
        action = ':DashboardChangeColorscheme<CR>',
        short_desc = "Change Color",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = {"<leader>", "f", ";", "s"},
        action = ':Dashboard<CR>',
        short_desc = "Open Startify Page",
        silent = true
    })


    mappings.register({
        mode = "n",
        key = {"<leader>", "c", "f"},
        action = ':DashboardNewFile<CR>',
        short_desc = "Create New File",
        silent = true
    })

end

return plugin
