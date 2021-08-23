local plugin = {}

plugin.core = {
    "glepnir/dashboard-nvim",

    setup = function()  -- Specifies code to run before this plugin is loaded.
        vim.g.dashboard_default_executive = 'telescope'
        vim.g.dashboard_preview_command = 'cat'
        vim.g.dashboard_preview_pipeline = 'lolcat'
        vim.g.dashboard_preview_file_height = 10
        vim.g.dashboard_preview_file_width = 70
        vim.g.dashboard_preview_file = vim.g.CONFIG..'/lua/util/neovim.txt'
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        vim.g.dashboard_custom_footer = {"🐬 Have A Good Day!"}
        --vim.g.dashboard_preview_pipeline = 'lolcat'
        --vim.g.dashboard_preview_file_height = 7
        --vim.g.dashboard_preview_file_width = 70
        vim.g.dashboard_custom_shortcut = {
            last_session       = 'SPC s l',
            find_history       = 'SPC f h',
            find_file          = 'SPC f f',
            new_file           = 'SPC c f',
            change_colorscheme = 'SPC f c',
            find_word          = 'SPC f q',
            book_marks         = 'SPC f m',
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
        action = ':DashboardFindHistory<CR>',
        short_desc = "Find History By Dashboard",
        silent = true
    })
    mappings.register({
        mode = "n",
        key = {"<leader>", "f", "c"},
        action = ':DashboardChangeColorscheme<CR>',
        short_desc = "Change Color",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = {"<leader>", "f", "s"},
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
    --nnoremap <silent> <Leader>cn :DashboardNewFile<CR>

end

return plugin
