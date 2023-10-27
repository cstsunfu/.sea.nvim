local plugin = {}

plugin.core = {
    "dhruvasagar/vim-table-mode",
    ft = { "vimwiki", "markdown" },
    init = function() -- Specifies code to run before this plugin is loaded.
        vim.g.table_mode_disable_mappings = 0
        vim.g.table_mode_disable_tableize_mappings = 0
    end,

    config = function() -- Specifies code to run after this plugin is loaded
    end,
}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = { "<leader>", "t", "m" },
        action = ':TableModeToggle<cr>',
        short_desc = "Toggle Table Mode",
        silent = true
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "t", "f", "e" },
        action = ':TableEvalFormulaLine<cr>',
        short_desc = "Table Fomule Eval",
        silent = true
    })

end

return plugin
