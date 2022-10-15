local plugin = {}

plugin.core = {
    "glepnir/dashboard-nvim",
    --as = "dashboard-nvim",

    setup = function()  -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded

        local home = os.getenv('HOME')
        local db = require('dashboard')
        db.session_directory = vim.fn.stdpath('cache').."/session"
        -- macos
        db.preview_command = 'cat | lolcat -F 0.3'
        ---- linux
        --db.preview_command = 'ueberzug'
        ---- FIXME: https://github.com/glepnir/dashboard-nvim/issues/79
        db.custom_footer = {"💎 Have A Good Day! "}
        db.preview_file_path = vim.g.CONFIG..'/lua/util/neovim.txt'
        db.preview_file_height = 10
        db.preview_file_width = 70
        db.custom_center = {
            {
                icon = '  ',
                desc = 'Recently opened files                   ',
                action =  'DashboardFindHistory',
                shortcut = '<leader> f r'
            },
            {
                icon = '  ',
                desc = 'Recently latest session                 ',
                shortcut = '<leader> s l',
                action ='SessionLoad'
            },
            {
                icon = '  ',
                desc = 'Find  File                              ',
                action = 'Telescope find_files find_command=rg,--hidden,--files',
                shortcut = '<leader> f f'
            },
            {
                icon = '  ',
                desc ='File Browser                            ',
                action =  'Telescope file_browser',
                shortcut = '<leader> f b'
            },
            {
                icon = '  ',
                desc = 'Find  word                              ',
                action = 'Telescope live_grep',
                shortcut = '<leader> f q'
            },
            --{
            --    icon = '  ',
            --    desc = 'Open Personal dotfiles                  ',
            --    action = 'Telescope dotfiles path=' .. home ..'/.dotfiles',
            --    shortcut = '<leader> f d'
            --},
        }
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
