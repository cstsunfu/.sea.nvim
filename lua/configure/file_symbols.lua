local plugin = {}

plugin.core = {
    "cstsunfu/symbols-outline.nvim", -- when the original repo fix all the bugs, we will change back to the original repo. https://github.com/simrat39/symbols-outline.nvim/issues/134
    as = "symbols-outline",
    cmd = { "SymbolsOutline" },
    setup = function() -- Specifies code to run before this plugin is loaded.
        --FIX: fold https://github.com/simrat39/symbols-outline.nvim/issues/7
        vim.cmd[[ 

            function! FoldOutline(lnum)
                " Marker for first character that isnt some guides or space
                let l:marker = '\v(\s|├|└|│)@!'

                " Get this line and next
                let l:this = getline(v:lnum)
                let l:next = getline(v:lnum + 1)

                " Calculate their indents, the 3 is spacing for the markers
                let l:this_indent = (match(l:this, l:marker) + 1) / 3
                let l:next_indent = (match(l:next, l:marker) + 1) / 3

                " If less indented than the next line, start a fold at
                " the level of the next line
                if l:this_indent < l:next_indent
                    return ">".l:next_indent

                " If more indented the the next line, end the fold
                elseif l:this_indent > l:next_indent
                    return "<".l:this_indent

                " Just return whatever the previous line is
                else
                    return "="
                endif
            endfunction

            function! FoldTextOutline()
                return substitute(getline(v:foldstart), '├\|└\|│', '-', 'g')
            endfunction

            autocmd FileType Outline execute 'setl foldlevel=1|setl foldexpr=FoldOutline(v:lnum)|setl foldtext=FoldTextOutline()|setl foldmethod=expr'
            autocmd FileType Outline execute 'setl nowrap'
        ]]
        vim.g.symbols_outline = {
            highlight_hovered_item = true,
            show_guides = true,
            auto_preview = true,
            position = 'left',
            relative_width = true,
            width = 18,
            auto_close = false,
            show_numbers = false,
            show_relative_numbers = false,
            show_symbol_details = true,
            preview_bg_highlight = 'Pmenu',
            keymaps = { -- These keymaps can be a string or a table for multiple keys
                close = {"q"},
                goto_location = "<Cr>",
                focus_location = "o",
                hover_symbol = "<C-space>",
                toggle_preview = "K",
                rename_symbol = "r",
                code_actions = "a",
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
    end,

    config = function() -- Specifies code to run after this plugin is loaded
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
