local plugin = {}

plugin.core = {
    "git@github.com:glacambre/firenvim.git",
    run = function() vim.fn['firenvim#install'](0) end,
    as = "firenvim",
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded

    end,

}


plugin.mapping = function()

end
return plugin
