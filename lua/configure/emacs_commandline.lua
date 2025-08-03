local plugin = {}

plugin.core = {
    --"houtsnip/vim-emacscommandline",
    "delphinus/emcl.nvim",
    event = "VeryLazy",
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("emcl").setup({})
    end,
}

plugin.mapping = function() end
return plugin
