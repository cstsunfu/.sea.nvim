local plugin = {}

plugin.core = {
    'mfussenegger/nvim-dap',
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("dap")
        vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
    end,

}

plugin.mapping = function()

end
return plugin
