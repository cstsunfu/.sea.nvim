local plugin = {}

plugin.core = {
    "glepnir/dashboard-nvim",
    event = "VimEnter",

    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        local cat_cmd = "cat | lolcat -F 0.3"
        if os.getenv("NO_LOLCAT") then
            cat_cmd = nil
        end
        require("dashboard").setup({
            -- config
            theme = "doom",
            hide = {
                statusline = false, -- hide statusline default is true
                tabline = true, -- hide the tabline
                winbar = true, -- hide winbar
            },
            preview = {
                command = cat_cmd,
                file_path = vim.g.CONFIG .. "/lua/util/neovim.txt", -- preview file path
                file_height = 15, -- preview file height
                file_width = 70, -- preview file width
            },
            config = {
                header = {
                    [[                                                                       ]],
                    [[                                                                       ]],
                    [[                                                                       ]],
                    [[                                                                       ]],
                    [[                                                                       ]],
                    [[     __      _    _____     ____     __    __    _____     __    __    ]],
                    [[    /  \    / )  / ___/    / __ \    ) )  ( (   (_   _)    \ \  / /    ]],
                    [[   / /\ \  / /  ( (__     / /  \ \  ( (    ) )    | |      () \/ ()    ]],
                    [[   ) ) ) ) ) )   ) __)   ( ()  () )  \ \  / /     | |      / _  _ \    ]],
                    [[  ( ( ( ( ( (   ( (      ( ()  () )   \ \/ /      | |     / / \/ \ \   ]],
                    [[  / /  \ \/ /    \ \___   \ \__/ /     \  /      _| |__  /_/      \_\  ]],
                    [[ (_/    \__/      \____\   \____/       \/      /_____( (/          \) ]],
                    [[                                                                       ]],
                    [[                                                                       ]],
                    [[                                                                       ]],
                    [[                                                                       ]],
                },
                footer = { "🐬 Have A Good Day! " },
                center = {
                    {
                        icon = "  ",
                        desc = "Recently Files                          ",
                        key = "LEADER f r",
                        action = "lua require('telescope').extensions.frecency.frecency{ sorter = require('telescope.config').values.file_sorter()}",
                        icon_hl = "Title",
                        desc_hl = "String",
                        key_hl = "Number",
                    },
                    {
                        icon = "  ",
                        desc = "Find  File                              ",
                        action = "Telescope find_files find_command=rg,--hidden,--files",
                        key = "LEADER f f",
                        icon_hl = "Title",
                        desc_hl = "String",
                        key_hl = "Number",
                    },
                    {
                        icon = "  ",
                        desc = "File Browser                            ",
                        action = "Telescope file_browser",
                        key = "LEADER f B",
                        icon_hl = "Title",
                        desc_hl = "String",
                        key_hl = "Number",
                    },
                    {
                        icon = "  ",
                        desc = "Open Personal Dotfiles                  ",
                        action = "lua require 'telescope.builtin'.find_files{ cwd = vim.g.HOME_PATH .. '/.sea.nvim'}",
                        key = "LEADER f d",
                        icon_hl = "Title",
                        desc_hl = "String",
                        key_hl = "Number",
                    },
                    {
                        icon = "  ",
                        desc = "Find  word                              ",
                        action = "Telescope live_grep",
                        key = "LEADER f q",
                        icon_hl = "Title",
                        desc_hl = "String",
                        key_hl = "Number",
                    },
                },
            },
        })
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")

    mappings.register({
        mode = "n",
        key = { "<leader>", "f", ";", "s" },
        action = ":Dashboard<CR>",
        short_desc = "Open Startify Page",
        silent = true,
    })
end

return plugin
