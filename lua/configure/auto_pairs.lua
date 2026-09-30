local plugin = {}

plugin.core = {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = {
        { "hrsh7th/nvim-cmp", enabled = vim.g.feature_groups.lsp == "builtin" },
    },
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("nvim-autopairs").setup({})

        local ok, cmp = pcall(require, "cmp")
        if ok then
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end
    end,
}

plugin.mapping = function() end

return plugin
