local plugin = {}

plugin.core = {
    "simrat39/symbols-outline.nvim",
    as = "symbols-outline",
    cmd = { "SymbolsOutline" },
    setup = function() -- Specifies code to run before this plugin is loaded.
        vim.g.symbols_outline = {
            highlight_hovered_item = true,
            show_guides = true,
            auto_preview = true,
            position = 'left',
            show_numbers = false,
            show_relative_numbers = false,
            show_symbol_details = true,
            keymaps = {
                close = "<Esc>",
                goto_location = "<Cr>",
                focus_location = "o",
                hover_symbol = "<C-space>",
                rename_symbol = "r",
                code_actions = "a",
            },
            lsp_blacklist = {},
            symbol_blacklist = {},
            symbols = {
                File = { icon = "", hl = "TSURI" },
                Module = { icon = "", hl = "TSNamespace" },
                Namespace = { icon = "", hl = "TSNamespace" },
                Package = { icon = "", hl = "TSNamespace" },
                Class = { icon = "", hl = "TSType" },
                Method = { icon = "", hl = "TSMethod" },
                Property = { icon = "", hl = "TSMethod" },
                Field = { icon = "", hl = "TSField" },
                Constructor = { icon = "", hl = "TSConstructor" },
                Enum = { icon = "ℰ", hl = "TSType" },
                Interface = { icon = "ﰮ", hl = "TSType" },
                Function = { icon = "", hl = "TSFunction" },
                Variable = { icon = "", hl = "TSConstant" },
                Constant = { icon = "", hl = "TSConstant" },
                String = { icon = "𝓐", hl = "TSString" },
                Number = { icon = "#", hl = "TSNumber" },
                Boolean = { icon = "⊨", hl = "TSBoolean" },
                Array = { icon = "", hl = "TSConstant" },
                Object = { icon = "⦿", hl = "TSType" },
                Key = { icon = "🔐", hl = "TSType" },
                Null = { icon = "NULL", hl = "TSType" },
                EnumMember = { icon = "", hl = "TSField" },
                Struct = { icon = "", hl = "TSType" },
                Event = { icon = "🗲", hl = "TSType" },
                Operator = { icon = "+", hl = "TSOperator" },
                TypeParameter = { icon = "𝙏", hl = "TSParameter" }
            }
        }
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        vim.g.symbols_outline = {
            highlight_hovered_item = true,
            show_guides = true,
            auto_preview = true,
            position = 'left',
            show_numbers = false,
            show_relative_numbers = false,
            show_symbol_details = true,
            keymaps = {
                close = "<Esc>",
                goto_location = "<Cr>",
                focus_location = "o",
                hover_symbol = "<C-space>",
                rename_symbol = "r",
                code_actions = "a",
            },
            lsp_blacklist = {},
            symbol_blacklist = {},
            symbols = {
                File = { icon = "", hl = "TSURI" },
                Module = { icon = "", hl = "TSNamespace" },
                Namespace = { icon = "", hl = "TSNamespace" },
                Package = { icon = "", hl = "TSNamespace" },
                Class = { icon = "", hl = "TSType" },
                Method = { icon = "", hl = "TSMethod" },
                Property = { icon = "", hl = "TSMethod" },
                Field = { icon = "", hl = "TSField" },
                Constructor = { icon = "", hl = "TSConstructor" },
                Enum = { icon = "ℰ", hl = "TSType" },
                Interface = { icon = "ﰮ", hl = "TSType" },
                Function = { icon = "", hl = "TSFunction" },
                Variable = { icon = "", hl = "TSConstant" },
                Constant = { icon = "", hl = "TSConstant" },
                String = { icon = "𝓐", hl = "TSString" },
                Number = { icon = "#", hl = "TSNumber" },
                Boolean = { icon = "⊨", hl = "TSBoolean" },
                Array = { icon = "", hl = "TSConstant" },
                Object = { icon = "⦿", hl = "TSType" },
                Key = { icon = "🔐", hl = "TSType" },
                Null = { icon = "NULL", hl = "TSType" },
                EnumMember = { icon = "", hl = "TSField" },
                Struct = { icon = "", hl = "TSType" },
                Event = { icon = "🗲", hl = "TSType" },
                Operator = { icon = "+", hl = "TSOperator" },
                TypeParameter = { icon = "𝙏", hl = "TSParameter" }
            }
        }
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
