local plugin = {}

plugin.core = {
    "folke/trouble.nvim",
    --    dependencies = { { 'nvim-tree/nvim-web-devicons' } },
    event = "VeryLazy",
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function()          -- Specifies code to run after this plugin is loaded
        require("trouble").setup({
            position = "bottom", -- position of the list can be: bottom, top, left, right
        })
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
    mappings.register({
        mode = "n",
        key = { "g", "T" },
        action = "<cmd>TroubleToggle lsp_references<cr>",
        short_desc = "Goto Trouble Reference",
        noremap = true,
        silent = false,
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "l", "t" },
        action = "<cmd>Trouble diagnostics toggle focus=true filter.buf=0<cr>",
        short_desc = "Trouble Diagnostics",
        noremap = true,
        silent = false,
    })

    --mappings.register({
    --    mode = "n",
    --    key = { "<leader>", "l", "q" },
    --    action = "<cmd>TroubleToggle quickfix<cr>",
    --    short_desc = "Trouble Quickfix",
    --    noremap = true,
    --    silent = false,
    --})

    --mappings.register({
    --    mode = "n",
    --    key = { "<leader>", "l", "w" },
    --    action = "<cmd>TroubleToggle workspace_diagnostics<cr>",
    --    short_desc = "Trouble Workspace",
    --    silent = false,
    --    noremap = true,
    --})

    --mappings.register({
    --    mode = "n",
    --    key = { "<leader>", "l", "l" },
    --    action = "<cmd>TroubleToggle loclist<cr>",
    --    short_desc = "Trouble Loclist",
    --    noremap = true,
    --    silent = false,
    --})

    --mappings.register({
    --    mode = "n",
    --    key = { "<leader>", "l", "d" },
    --    action = "<cmd>TroubleToggle document_diagnostics<cr>",
    --    short_desc = "Trouble Document",
    --    noremap = true,
    --    silent = false,
    --})
end
return plugin
