local plugin = {}

plugin.core = {
    "oflisback/obsidian-bridge.nvim",
    event = {
        "BufReadPre *.md",
        "BufNewFile *.md",
    },
    lazy = true,

    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("obsidian-bridge").setup({
            scroll_sync = true,
        })
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
    mappings.register({
        mode = "n",
        key = { "<leader>", "o", "c" },
        action = ":ObsidianBridgeTelescopeCommand<cr>",
        short_desc = "ObsidianCommand",
    })
end

return plugin
