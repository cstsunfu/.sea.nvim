local plugin = {}

plugin.core = {
    'mfussenegger/nvim-dap-python',
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
         require('dap-python').setup('~/anaconda3/bin/python')
    end,

}

plugin.mapping = function()

end
return plugin
