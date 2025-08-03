local plugin = {}

plugin.core = {
    "oflisback/obsidian-bridge.nvim",
    lazy = true,
    ft = { "vimwiki", "markdown" },

    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("obsidian-bridge").setup({
            scroll_sync = true,
            obsidian_server_address = "http://localhost:27123",
            warnings = true, -- Show misconfiguration warnings
            cert_path = nil, -- See "SSL configuration" section below
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
