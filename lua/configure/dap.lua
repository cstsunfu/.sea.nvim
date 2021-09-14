local plugin = {}

plugin.core = {
    'git@github.com:mfussenegger/nvim-dap.git',
    as = "nvim-dap",
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("dap")
        vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
    end,

}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = {"<leader>", "d", "b"},
        action = ":lua require'dap'.toggle_breakpoint()<cr>",
        short_desc = "Toggle Debug Breakpoint",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = {"<leader>", "d", "c"},
        action = ":lua require'dap'.continue()<cr>",
        short_desc = "Debug Continue",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = {"<leader>", "d", "i"},
        action = ":lua require'dap'.step_into()<cr>",
        short_desc = "Debug Step Into",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = {"<leader>", "d", "o"},
        action = ":lua require'dap'.step_over()<cr>",
        short_desc = "Debug Step Over",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = {"<leader>", "d", "r"},
        action = ":lua require'dap'.repl.open()<cr>",
        short_desc = "Debug Repl Open",
        silent = true
    })

end
return plugin
