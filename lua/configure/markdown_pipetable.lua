local plugin = {}

plugin.core = {
    "dominic-righthere/markdown-pipetable.nvim",
    ft = { "markdown" },

    config = function() -- Specifies code to run after this plugin is loaded
        require("pipetable").setup({
            enabled = true,
            auto_enter = true,
            -- Keep the Markdown source as the single source of truth.
            format_on_edit = false,
            -- Keep operation mappings separate from vim-table-mode's <leader>t group.
            keys = {
                leader = "<localleader>p",
            },
        })
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
    mappings.register({
        mode = "n",
        key = { "<leader>", "t", "a" },
        action = ":Pipetable<cr>",
        short_desc = "Toggle PipeTable",
        silent = true,
    })
end

return plugin
