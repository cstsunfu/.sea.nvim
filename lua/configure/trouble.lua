local plugin = {}

plugin.core = {
    "folke/trouble.nvim",
    --requires = { { 'kyazdani42/nvim-web-devicons' } },
    setup = function() -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("trouble").setup  {
            position = "bottom", -- position of the list can be: bottom, top, left, right
            height = 10, -- height of the trouble list when position is top or bottom
            width = 50, -- width of the list when position is left or right
            icons = true, -- use devicons for filenames
            mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
            fold_open = "", -- icon used for open folds
            fold_closed = "", -- icon used for closed folds
            group = true, -- group results by file
            padding = true, -- add an extra new line on top of the list
            action_keys = { -- key mappings for actions in the trouble list
                -- map to {} to remove a mapping, for example:
                -- close = {},
                close = "q", -- close the list
                cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
                refresh = "r", -- manually refresh
                jump = {"<cr>", "<tab>"}, -- jump to the diagnostic or open / close folds
                open_split = { "<c-x>" }, -- open buffer in new split
                open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
                open_tab = { "<c-t>" }, -- open buffer in new tab
                jump_close = {"o"}, -- jump to the diagnostic and close the list
                toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
                toggle_preview = "P", -- toggle auto_preview
                hover = "K", -- opens a small popup with the full multiline message
                preview = "p", -- preview the diagnostic location
                close_folds = {"zM", "zm"}, -- close all folds
                open_folds = {"zR", "zr"}, -- open all folds
                toggle_fold = {"zA", "za"}, -- toggle fold of current file
                previous = "k", -- preview item
                next = "j" -- next item
            },
            indent_lines = true, -- add an indent guide below the fold icons
            auto_open = false, -- automatically open the list when you have diagnostics
            auto_close = false, -- automatically close the list when you have no diagnostics
            auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
            auto_fold = false, -- automatically fold a file trouble list at creation
            auto_jump = {"lsp_definitions"}, -- for the given modes, automatically jump if there is only a single result
            signs = {
                -- icons / text used for a diagnostic
                error = "",
                warning = "",
                hint = "",
                information = "",
                other = "﫠"
            },
            use_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
        }
    end,
}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = { "g", "T" },
        action = '<cmd>TroubleToggle lsp_references<cr>',
        short_desc = "Goto Trouble Reference",
        noremap = true,
        silent = false
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "l", "t" },
        action = '<cmd>TroubleToggle<cr>',
        short_desc = "Trouble Toggle",
        noremap = true,
        silent = false
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "l", "q" },
        action = '<cmd>TroubleToggle quickfix<cr>',
        short_desc = "Trouble Quickfix",
        noremap = true,
        silent = false
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "l", "w" },
        action = '<cmd>TroubleToggle workspace_diagnostics<cr>',
        short_desc = "Trouble Workspace",
        silent = false,
        noremap = true
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "l", "l" },
        action = '<cmd>TroubleToggle loclist<cr>',
        short_desc = "Trouble Loclist",
        noremap = true,
        silent = false
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "l", "d" },
        action = '<cmd>TroubleToggle document_diagnostics<cr>',
        short_desc = "Trouble Document",
        noremap = true,
        silent = false
    })
end
return plugin
