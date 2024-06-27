local plugin = {}

plugin.core = {
    "hedyhli/outline.nvim", -- the fork version, caused by the original repo has some bugs and not active for a long time.
    cmd = { "Outline" },
    init = function()       -- Specifies code to run before this plugin is loaded.
        local get_reserve_outline_buf = function()
            local wins = vim.api.nvim_tabpage_list_wins(0)
            local cur_buf = vim.api.nvim_win_get_buf(0)
            local reserved_outline = nil
            if #wins == 2 then
                local reserved = nil
                for _, w in pairs(vim.api.nvim_tabpage_list_wins(0)) do
                    local b = vim.api.nvim_win_get_buf(w)
                    if b ~= cur_buf then
                        reserved = b
                    end
                end
                if reserved ~= nil then
                    local ft = vim.api.nvim_buf_get_option(reserved, "filetype")
                    -- if ft starts with "NvimTree"
                    if string.find(ft, "Outline") then
                        reserved_outline = reserved
                    end
                end
            end
            return reserved_outline
        end
        vim.api.nvim_create_autocmd({ "WinClosed" }, {
            callback = function()
                local reserved_outline = get_reserve_outline_buf()
                if reserved_outline ~= nil then
                    vim.cmd("qa")
                end
            end,
            pattern = "*",
        })
        vim.api.nvim_create_autocmd({ "BufDelete" }, {
            callback = function()
                local reserved_outline = get_reserve_outline_buf()
                if reserved_outline ~= nil then
                    -- delete the reserved_outline buffer
                    vim.api.nvim_buf_delete(reserved_outline, { force = true })
                end
            end,
            pattern = "*",
        })
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        local opts = {
            guides = {
                enabled = false,
            },
            keymaps = {
                close = { "q" },
                fold = "h",
                fold_all = "H",
                fold_reset = "R",
                goto_location = "<Cr>",
                hover_symbol = "s",
                peek_location = "o",
                rename_symbol = "r",
                toggle_preview = "K",
                unfold = "l",
                unfold_all = "L",
            },
            outline_items = {
                highlight_hovered_item = true,
                show_symbol_details = true,
            },
            outline_window = {
                winhl = 'Normal:NormalContrast',
                auto_jump = true,
                auto_close = false,
                position = "left",
                relative_width = true,
                show_numbers = false,
                show_relative_numbers = false,
                width = 18,
                wrap = false,
            },
            preview_window = {
                auto_preview = false,
                border = "rounded",
                winhl = "Normal:Pmenu",
            },
            provider = {
                lsp = {
                    blacklist_clients = {},
                },
            },
            symbol_folding = {
                auto_unfold_hover = true,
                markers = { "", "" },
            },
            symbols = {
                --filter = {
                --    exclude = true,
                --},
                filter = nil,
                icons = {
                    Array = {
                        hl = "@constant",
                        icon = "",
                    },
                    Boolean = {
                        hl = "@boolean",
                        icon = "",
                    },
                    Component = {
                        hl = "@function",
                        icon = "",
                    },
                    Constant = {
                        hl = "@constant",
                        icon = "",
                    },
                    Constructor = {
                        hl = "@constructor",
                        icon = "",
                    },
                    Enum = {
                        hl = "@type",
                        icon = "ℰ",
                    },
                    EnumMember = {
                        hl = "@field",
                        icon = "",
                    },
                    Event = {
                        hl = "@type",
                        icon = "",
                    },
                    Field = {
                        hl = "@field",
                        icon = "",
                    },
                    File = {
                        hl = "@text.uri",
                        icon = "",
                    },
                    Fragment = {
                        hl = "@constant",
                        icon = "",
                    },
                    Function = {
                        hl = "@function",
                        icon = "ƒ",
                    },
                    Interface = {
                        hl = "@type",
                        icon = "ﰮ",
                    },
                    Key = {
                        hl = "@type",
                        icon = "",
                    },
                    Method = {
                        hl = "@method",
                        icon = "ƒ",
                    },
                    Module = {
                        hl = "@namespace",
                        icon = "",
                    },
                    Null = {
                        hl = "@type",
                        icon = " ",
                    },
                    Number = {
                        hl = "@number",
                        icon = "#",
                    },
                    Object = {
                        hl = "@type",
                        icon = "",
                    },
                    Operator = {
                        hl = "@operator",
                        icon = "",
                    },
                    Package = {
                        hl = "@namespace",
                        icon = "",
                    },
                    Property = {
                        hl = "@method",
                        icon = "",
                    },
                    String = {
                        hl = "@string",
                        icon = "𝓢",
                    },
                    Struct = {
                        hl = "@type",
                        icon = "ﴯ",
                    },
                    TypeParameter = {
                        hl = "@parameter",
                        icon = "",
                    },
                    Variable = {
                        hl = "@constant",
                        icon = "",
                    },
                },
            },
        }

        require("outline").setup(opts)
    end,
}
plugin.mapping = function()
    local mappings = require("core.mapping")
    mappings.register({
        mode = "n",
        key = { "<leader>", "t", "l" },
        action = ":Outline<cr>",
        short_desc = "Tag List",
        silent = true,
    })
end
return plugin
