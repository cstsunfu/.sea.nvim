local plugin = {}

plugin.core = {
    "Pocco81/DAPInstall.nvim",
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        local dap_install = require("dap-install")
        dap_install.setup({
            installation_path = vim.fn.stdpath("data") .. "/dapinstall/",
            verbosely_call_debuggers = true,
        })
    end,

}

plugin.mapping = function()

end
return plugin
