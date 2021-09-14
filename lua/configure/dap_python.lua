local plugin = {}

plugin.core = {
    'git@github.com:mfussenegger/nvim-dap-python.git',
    as = "nvim-dap-python",
    requires = {{"git@github.com:mfussenegger/nvim-dap.git", as = "nvim-dap"}},
    
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
         require('dap-python').setup('~/anaconda3/envs/dlkit/bin/python')
    end,

}

plugin.mapping = function()

end
return plugin
