local plugin = {}

plugin.core = {
    "git@github.com:nvim-lua/plenary.nvim.git",
    opt=true,
    as = "plenary.nvim",
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
    end,
}

plugin.mapping = function()

end
return plugin
