local plugin = {}

plugin.core = {
    --"ray-x/navigator.lua", -- this plugin
    "glepnir/lspsaga.nvim",
    branch = "main",
    event = "LspAttach",
    dependencies = {
        {"nvim-tree/nvim-web-devicons"},
        --Please make sure you install markdown and markdown_inline parser
        {"nvim-treesitter/nvim-treesitter"}
    },


    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function()                                        -- Specifies code to run after this plugin is loaded
        require("lspsaga").setup({
            preview = {
                lines_above = 0,
                lines_below = 10,
            },
            scroll_preview = {
                scroll_down = "<C-f>",
                scroll_up = "<C-b>",
            },
            request_timeout = 2000,
            symbol_in_winbar = {
                enable = false,
            },
            -- See Customizing Lspsaga's Appearance
            ui = {
                -- This option only works in Neovim 0.9
                title = true,
                -- Border type can be single, double, rounded, solid, shadow.
                border = "rounded",
                winblend = 0,
                expand = "",
                collapse = "",
                code_action = "💡",
                incoming = " ",
                outgoing = " ",
                hover = ' ',
                kind = {},
            },

            -- For default options for each command, see below
            --finder = { ... },
            --code_action = { ... }
            lightbulb = {
                enable = true,
                enable_in_insert = false,
                sign = false,
                sign_priority = 40,
                virtual_text = true,
            },

        })
    end,

}
plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = { "g", "f" },
        action = '<cmd>Lspsaga lsp_finder<cr>',
        short_desc = "Lsp Finder",
        silent = false
    })
    mappings.register({
        mode = "n",
        key = { "g", "a" },
        action = '<cmd>Lspsaga code_action<cr>',
        short_desc = "Lsp Code Action",
        silent = false
    })
    mappings.register({
        mode = "n",
        key = { "g", "p" },
        action = '<cmd>Lspsaga peek_definition<cr>',
        short_desc = "Lsp Peek Definition",
        silent = false
    })
    mappings.register({
        mode = "n",
        key = { "g", "R" },
        action = '<cmd>Lspsaga rename<cr>',
        short_desc = "Lsp Rename",
        silent = false
    })
    mappings.register({
        mode = "n",
        key = { "K" },
        action = '<cmd>Lspsaga hover_doc<cr>',
        short_desc = "Displays Hover",
        desc = "Displays hover information about the symbol under the cursor in a floating window. Calling the function twice will jump into the floating window.",
        silent = false
    })
end
return plugin
