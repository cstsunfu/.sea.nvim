local plugin = {}

plugin.core = {
    "rcarriga/nvim-dap-ui",
    requires = {"mfussenegger/nvim-dap"},
    --after = {'nvim-dap'},
    
    setup = function()  -- Specifies code to run before this plugin is loaded.
        vim.fn.sign_define('DapBreakpoint', {text='', texthl='Debug', linehl='', numhl=''})
        vim.fn.sign_define('DapBreakpoint', {text='', texthl='Debug', linehl='', numhl=''})
        
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        --if not packer_plugins['nvim-dap'].loaded then
            --vim.cmd [[packadd nvim-dap]]
        --end
        local dap, dapui = require('dap'), require('dapui')
        dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
        dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
        dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end

        
        require("dapui").setup({
            icons = { expanded = "▾", collapsed = "▸" },
            mappings = {
                -- Use a table to apply multiple mappings
                expand = { "<CR>", "<2-LeftMouse>" },
                open = "o",
                remove = "d",
                edit = "e",
                repl = "r",
            },
            sidebar = {
                --open_on_start = true,
                -- You can change the order of elements in the sidebar
                elements = {
                    -- Provide as ID strings or tables with "id" and "size" keys
                    {
                        id = "scopes",
                        size = 0.25, -- Can be float or integer > 1
                    },
                    { id = "breakpoints", size = 0.25 },
                    { id = "stacks", size = 0.25 },
                    { id = "watches", size = 00.25 },
                },
                size = 40,
                position = "left", -- Can be "left", "right", "top", "bottom"
            },
            tray = {
                --open_on_start = true,
                elements = { "repl" },
                size = 10,
                position = "bottom", -- Can be "left", "right", "top", "bottom"
            },
            floating = {
                max_height = nil, -- These can be integers or a float between 0 and 1.
                max_width = nil, -- Floats will be treated as percentage of your screen.
                mappings = {
                    close = { "q", "<Esc>" },
                },
            },
            windows = { indent = 1 },
        })
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

    mappings.register({
        mode = "n",
        key = {"<leader>", "d", "q"},
        action = ":lua require'dapui'.close()<cr> :lua require('dap').disconnect()<cr> :lua require('dap').close()<cr>",
        short_desc = "Debug Quit",
        silent = true
    })


end
return plugin



