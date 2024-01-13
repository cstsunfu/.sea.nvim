local plugin = {}

plugin.core = {
    "j-hui/fidget.nvim",
    event = "BufEnter",
    tag = "legacy", -- FIXME: check the status of the rewrite plugin
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("fidget").setup({})
    end,
}

plugin.mapping = function() end

return plugin
