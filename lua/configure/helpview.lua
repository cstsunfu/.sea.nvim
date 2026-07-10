local plugin = {}

plugin.core = {
    "OXY2DEV/helpview.nvim",
    lazy = false,
    config = function()
        require("helpview").setup({
            preview = {
                icon_provider = "devicons",
            },
        })
    end,
}

plugin.mapping = function() end

return plugin
