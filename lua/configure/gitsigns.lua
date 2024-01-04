local plugin = {}

plugin.core = {
    "lewis6991/gitsigns.nvim",
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        vim.api.nvim_exec("highlight! GitSignsAdd guifg=#00FF00", false)
        vim.api.nvim_exec("highlight! GitSignsChange guifg=#73cef4", false)
        vim.api.nvim_exec("highlight! GitSignsDelete guifg=#ffc24b", false)
        vim.api.nvim_exec("highlight! GitSignsUntracked guifg=#555555", false)
        -- work with statuscol.lua
        require("gitsigns").setup({
            signs = {
                add = {
                    hl = "GitSignsAdd",
                    text = "▎",
                    numhl = "GitSignsAddNr",
                    linehl = "GitSignsAddLn",
                },
                change = {
                    hl = "GitSignsChange",
                    text = "▎",
                    numhl = "GitSignsChangeNr",
                    linehl = "GitSignsChangeLn",
                },
                delete = {
                    hl = "GitSignsDelete",
                    text = "▎",

                    numhl = "GitSignsDeleteNr",
                    linehl = "GitSignsDeleteLn",
                },
                topdelete = {
                    hl = "GitSignsDelete",
                    text = "▎",
                    numhl = "GitSignsDeleteNr",
                    linehl = "GitSignsDeleteLn",
                },
                changedelete = {
                    hl = "GitSignsChange",
                    text = "▎",
                    numhl = "GitSignsChangeNr",
                    linehl = "GitSignsChangeLn",
                },
                untracked = {
                    hl = "GitSignsUntracked",
                    text = "▎",
                    numhl = "GitSignsUntrackedNr",
                    linehl = "GitSignsUntrackedLn",
                },
            },
            signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
            numhl = false,
            linehl = false,
            watch_gitdir = { interval = 1000 },
            sign_priority = 6,
            update_debounce = 100,
            status_formatter = nil, -- Use default
        })
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
    mappings.register({
        mode = "n",
        key = { "<leader>", "g", "i" },
        action = ":Gitsigns toggle_signs<cr>",
        short_desc = "Git Indicator Toggle",
        silent = true,
    })
    --keymaps = {
    ---- Default keymap options
    --noremap = true,

    --['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
    --['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},

    --['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
    --['v <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    --['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
    --['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
    --['v <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    --['n <leader>hR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
    --['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
    --['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',

    ---- Text objects
    --['o ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
    --['x ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>'
    --},
end

return plugin
