local plugin = {}

plugin.core = {
    "hedyhli/outline.nvim", -- the fork version, caused by the original repo has some bugs and not active for a long time.
    cmd = { "Outline" },
    init = function()       -- Specifies code to run before this plugin is loaded.
        vim.api.nvim_create_autocmd("BufEnter", {
            callback = function()
                if vim.bo.filetype == "Outline" and vim.fn.winnr('$') == 1 then
                    vim.cmd("q")
                end
            end,
        })
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        local opts = {
            guides = {
                enabled = false,
            },
            auto_update_events = {
                refresh = true,
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
                    Constant = {
                        hl = "@constant",
                        icon = "󰎠",
                    },
                    Function = {
                        hl = "@function",
                        icon = "󰊕",
                    },
                    Method = {
                        hl = "@method",
                        icon = "",
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
