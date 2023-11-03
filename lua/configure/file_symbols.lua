local plugin = {}

plugin.core = {
    "hedyhli/symbols-outline.nvim", -- the fork version, casued by the original repo has some bugs and not active for a long time.
    --"simrat39/symbols-outline.nvim", -- when the original repo fix all the bugs, we will change back to the original repo. https://github.com/simrat39/symbols-outline.nvim/issues/176
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        local opts = {
            highlight_hovered_item = true,
            show_guides = true,
            border = "rounded",
            auto_preview = false,
            auto_goto = true,
            position = 'left',
            relative_width = true,
            width = 18,
            auto_close = false,
            show_numbers = false,
            show_relative_numbers = false,
            show_symbol_details = true,
            preview_bg_highlight = 'Pmenu',
            --preview_bg_highlight = 'Normal',
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
                File = { icon = "", hl = "@text.uri" },
                Module = { icon = "", hl = "@namespace" },
                Namespace = { icon = "", hl = "@namespace" },
                Package = { icon = "", hl = "@namespace" },
                Class = { icon = "𝓒", hl = "@type" },
                Method = { icon = "ƒ", hl = "@method" },
                Property = { icon = "", hl = "@method" },
                Field = { icon = "", hl = "@field" },
                Constructor = { icon = "", hl = "@constructor" },
                Enum = { icon = "ℰ", hl = "@type" },
                Interface = { icon = "ﰮ", hl = "@type" },
                Function = { icon = "ƒ", hl = "@function" },
                Variable = { icon = "", hl = "@constant" },
                Constant = { icon = "", hl = "@constant" },
                String = { icon = "𝓐", hl = "@string" },
                Number = { icon = "#", hl = "@number" },
                Boolean = { icon = "⊨", hl = "@boolean" },
                Array = { icon = "", hl = "@constant" },
                Object = { icon = "⦿", hl = "@type" },
                Key = { icon = "", hl = "@type" },
                Null = { icon = "NULL", hl = "@type" },
                EnumMember = { icon = "", hl = "@field" },
                Struct = { icon = "𝓢", hl = "@type" },
                Event = { icon = "🗲", hl = "@type" },
                Operator = { icon = "+", hl = "@operator" },
                TypeParameter = { icon = "𝙏", hl = "@parameter" },
                Component = { icon = "", hl = "@function" },
                Fragment = { icon = "", hl = "@constant" },
                --File = {icon = "", hl = "TSURI"},
                --Class = {icon = "ﴯ", hl = "TSType"},
                --Module = {icon = "", hl = "TSFunction"},
                --Namespace = {icon = "", hl = "TSNamespace"},
                --Package = {icon = "", hl = "TSNamespace"},
                --Method = {icon = "", hl = "TSMethod"},
                --Property = {icon = "", hl = "TSProperty"},
                --Field = {icon = "", hl = "TSSymbol"},
                --Constructor = {icon = "", hl = "TSConstructor"},
                --Enum = {icon = "", hl = "TSNumber"},
                --Interface = {icon = "", hl = "TSType"},
                --Function = {icon = "", hl = "TSFunction"},
                --Variable = {icon = "", hl = "TSTag"},
                --Constant = {icon = "", hl = "TSConstant"},
                --String = {icon = "", hl = "TSString"},
                --Number = {icon = "", hl = "TSNumber"},
                --Boolean = {icon = "", hl = "TSBoolean"},
                --Array = {icon = "", hl = "TSConstant"},
                --Object = {icon = "", hl = "TSOperator"},
                --Key = {icon = "", hl = "TSTag"},
                --Null = {icon = " ", hl = "TSType"},
                --EnumMember = {icon = "", hl = "TSNumber"},
                --Struct = {icon = "ﴯ", hl = "TSType"},
                --Event = {icon = "", hl = "TSType"},
                --Operator = {icon = "", hl = "TSOperator"},
                --TypeParameter = {icon = " ", hl = "TSType"}
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
