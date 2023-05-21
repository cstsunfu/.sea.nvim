local plugin = {}

plugin.core = {
    "enddeadroyal/symbols-outline.nvim", --TODO: when the original repo fix all the bugs, we will change back to the original repo. https://github.com/simrat39/symbols-outline.nvim/issues/176
    branch = 'bugfix/symbol-hover-misplacement',
    --"simrat39/symbols-outline.nvim", -- when the original repo fix all the bugs, we will change back to the original repo. https://github.com/simrat39/symbols-outline.nvim/issues/176
    setup = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        local opts = {
            highlight_hovered_item = true,
            show_guides = true,
            border = "rounded",
            auto_preview = true,
            position = 'left',
            relative_width = true,
            width = 18,
            auto_close = false,
            show_numbers = false,
            show_relative_numbers = false,
            show_symbol_details = true,
            --preview_bg_highlight = 'Pmenu',
            preview_bg_highlight = 'Normal',
            autofold_depth = nil,
            auto_unfold_hover = true,
            fold_markers = { '', '' },
            wrap = false,
            keymaps = { -- These keymaps can be a string or a table for multiple keys
                goto_location = "<Cr>",
                focus_location = "o",
                rename_symbol = "r",
                close = { "q" },
                hover_symbol = "s",
                toggle_preview = "K",
                --code_actions = "a", -- TODO
                fold = "h",
                unfold = "l",
                fold_all = "H",
                unfold_all = "L",
                fold_reset = "R",
            },
            lsp_blacklist = {},
            symbol_blacklist = {},
            symbols = {
                File = {icon = "", hl = "TSURI"},
                Class = {icon = "ﴯ", hl = "TSType"},
                Module = {icon = "", hl = "TSFunction"},
                Namespace = {icon = "", hl = "TSNamespace"},
                Package = {icon = "", hl = "TSNamespace"},
                Method = {icon = "", hl = "TSMethod"},
                Property = {icon = "", hl = "TSProperty"},
                Field = {icon = "", hl = "TSSymbol"},
                Constructor = {icon = "", hl = "TSConstructor"},
                Enum = {icon = "", hl = "TSNumber"},
                Interface = {icon = "", hl = "TSType"},
                Function = {icon = "", hl = "TSFunction"},
                Variable = {icon = "", hl = "TSTag"},
                Constant = {icon = "", hl = "TSConstant"},
                String = {icon = "", hl = "TSString"},
                Number = {icon = "", hl = "TSNumber"},
                Boolean = {icon = "", hl = "TSBoolean"},
                Array = {icon = "", hl = "TSConstant"},
                Object = {icon = "", hl = "TSOperator"},
                Key = {icon = "", hl = "TSTag"},
                Null = {icon = " ", hl = "TSType"},
                EnumMember = {icon = "", hl = "TSNumber"},
                Struct = {icon = "ﴯ", hl = "TSType"},
                Event = {icon = "", hl = "TSType"},
                Operator = {icon = "", hl = "TSOperator"},
                TypeParameter = {icon = " ", hl = "TSType"}
            }
        }

        require("symbols-outline").setup(opts)
    end,

}
plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = { "<leader>", "t", "l" },
        action = ':SymbolsOutline<cr>',
        short_desc = "Tag List",
        silent = true
    })

end
return plugin
