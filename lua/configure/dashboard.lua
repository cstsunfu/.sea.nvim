local plugin = {}

plugin.core = {
    "glepnir/dashboard-nvim",
    --as = "dashboard-nvim",
    event = 'VimEnter',

    setup = function()  -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require('dashboard').setup {
              -- config
              theme = "doom",
              hide = {
                  statusline = false,   -- hide statusline default is true
                  tabline = true,      -- hide the tabline
                  winbar = true,       -- hide winbar
              },
              preview = {
                  command = "cat | lolcat -F 0.3",
                  file_path =  vim.g.CONFIG..'/lua/util/neovim.txt',  -- preview file path
                  file_height = 15,   -- preview file height
                  file_width = 70,   -- preview file width
              },
              config = {
                  footer = {"🐬 Have A Good Day! "},
                  center = {
                      {
                          icon = '  ',
                          desc = 'Recently opened files                   ',
                          action =  'DashboardFindHistory',
                          key = '<leader> f r',
                          icon_hl = 'Title',
                          desc_hl = 'String',
                          key_hl = 'Number',
                      },
                      {
                          icon = '  ',
                          desc = 'Recently latest session                 ',
                          key = '<leader> s l',
                          action ='SessionLoad',
                          icon_hl = 'Title',
                          desc_hl = 'String',
                          key_hl = 'Number',
                      },
                      {
                          icon = '  ',
                          desc = 'Find  File                              ',
                          action = 'Telescope find_files find_command=rg,--hidden,--files',
                          key = '<leader> f f',
                          icon_hl = 'Title',
                          desc_hl = 'String',
                          key_hl = 'Number',
                      },
                      {
                          icon = '  ',
                          desc ='File Browser                            ',
                          action =  'Telescope file_browser',
                          key = '<leader> f b',
                          icon_hl = 'Title',
                          desc_hl = 'String',
                          key_hl = 'Number',
                      },
                      {
                          icon = '  ',
                          desc = 'Find  word                              ',
                          action = 'Telescope live_grep',
                          key = '<leader> f q',
                          icon_hl = 'Title',
                          desc_hl = 'String',
                          key_hl = 'Number',
                      },
                      --{
                          --    icon = '  ',
                          --    desc = 'Open Personal dotfiles                  ',
                          --    action = 'Telescope dotfiles path=' .. home ..'/.dotfiles',
                          --    shortcut = '<leader> f d'
                          --},
                      }

              },

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
