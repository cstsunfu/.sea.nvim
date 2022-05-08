local plugin = {}

plugin.core = {
    "rcarriga/nvim-dap-ui",
    requires = { "mfussenegger/nvim-dap" },
    --after = {'nvim-dap'},

    setup = function() -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        --if not packer_plugins['nvim-dap'].loaded then
        --vim.cmd [[packadd nvim-dap]]
        --end
        local dap, dapui = require('dap'), require('dapui')
        vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'Debug', linehl = '', numhl = '' })
        vim.fn.sign_define('DapStopped', { text = '➤', texthl = 'DiagnosticInfo', linehl = '', numhl = '' })
        vim.fn.sign_define('DapBreakpointCondition', { text = '⌚', texthl = 'DiagnosticChanged', linehl = '', numhl = '' })
        vim.fn.sign_define('DapBreakpointRejected', { text = '⊙', texthl = 'DiagnosticWarning', linehl = '', numhl = '' })
        vim.fn.sign_define('DapLogPoint', { text = '✉ ', texthl = 'DiagnosticHint', linehl = '', numhl = '' })

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
            --expand_lines = vim.fn.has("nvim-0.7"),
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
        vim.cmd([[autocmd filetype dapui_stacks,dapui_breakpoints,dapui_watches,dapui_scopes setlocal norelativenumber]])
        vim.cmd([[autocmd filetype dapui_stacks,dapui_breakpoints,dapui_watches,dapui_scopes setlocal nonumber]])
    end,

}

plugin.mapping = function()
    local mappings = require('core.mapping')
    -- quit
    mappings.register({
        mode = "n",
        key = { "<leader>", "d", "q" },
        action = ":lua require'dapui'.close()<cr> :lua require('dap').disconnect()<cr> :lua require('dap').close()<cr><cr> :lua require('dap').repl.close()<cr>",
        short_desc = "Debug Quit(F2)",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = { "<F2>" },
        action = ":lua require'dapui'.close()<cr> :lua require('dap').disconnect()<cr> :lua require('dap').close()<cr><cr> :lua require('dap').repl.close()<cr>",
        short_desc = "Debug Quit",
        silent = true
    })

    -- clear breakpoints
    mappings.register({
        mode = "n",
        key = { "<leader>", "d", "C" },
        action = ":lua require'dap'.clear_breakpoints()<cr>",
        short_desc = "Debug Clear Breakpoint(F4)",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = { "<F4>" },
        action = ":lua require'dap'.clear_breakpoints()<cr>",
        short_desc = "Debug Clear Breakpoint(F4)",
        silent = true
    })

    -- continue
    mappings.register({
        mode = "n",
        key = { "<leader>", "d", "c" },
        action = ":lua require'dap'.continue()<cr>",
        short_desc = "Debug Continue",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = { "<F5>" },
        action = ":lua require'dap'.continue()<cr>",
        short_desc = "Debug Continue",
        silent = true
    })

    -- step back
    mappings.register({
        mode = "n",
        key = { "<leader>", "d", "B" },
        action = ":lua require'dap'.step_back()<cr>",
        short_desc = "Debug Step Back(F6)",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = { "<F6>" },
        action = ":lua require'dap'.step_back()<cr>",
        short_desc = "Debug Step Back",
        silent = true
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "d", "a" },
        action = nil,
        short_desc = "Advanced Debug",
        silent = true
    })

    -- whole control breakpoint
    mappings.register({
        mode = "n",
        key = { "<leader>", "d", "a", "w" },
        action = ":lua require'dap'.toggle_breakpoint(vim.fn.input('Breakpoint condition: '), vim.fn.input('Hit Condition: '), vim.fn.input('Log Message: '))<cr>",
        short_desc = "Advanced Breakpoint(F7)",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = { "<F7>" },
        action = ":lua require'dap'.toggle_breakpoint(vim.fn.input('Breakpoint condition: '), vim.fn.input('Hit Condition: '), vim.fn.input('Log Message: '))<cr>",
        short_desc = "Advanced Breakpoint",
        silent = true
    })

    -- condition breakpoint
    mappings.register({
        mode = "n",
        key = { "<leader>", "d", "a", "c" },
        action = ":lua require'dap'.toggle_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>",
        short_desc = "Condition Breakpoint(F8)",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = { "<F8>" },
        action = ":lua require'dap'.toggle_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>",
        short_desc = "Condition Breakpoint",
        silent = true
    })

    -- breakpoint
    mappings.register({
        mode = "n",
        key = { "<leader>", "d", "b" },
        action = ":lua require'dap'.toggle_breakpoint()<cr>",
        short_desc = "Debug Breakpoint(F9)",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = { "<F9>" },
        action = ":lua require'dap'.toggle_breakpoint()<cr>",
        short_desc = "Debug Breakpoint",
        silent = true
    })

    -- step over
    mappings.register({
        mode = "n",
        key = { "<leader>", "d", "o" },
        action = ":lua require'dap'.step_over()<cr>",
        short_desc = "Debug Step Over(F10)",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = { "<F10>" },
        action = ":lua require'dap'.step_over()<cr>",
        short_desc = "Debug Step Over",
        silent = true
    })


    -- step into
    mappings.register({
        mode = "n",
        key = { "<leader>", "d", "i" },
        action = ":lua require'dap'.step_into()<cr>",
        short_desc = "Debug Step Into(F11)",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = { "<F11>" },
        action = ":lua require'dap'.step_into()<cr>",
        short_desc = "Debug Step Into",
        silent = true
    })

    -- step out
    mappings.register({
        mode = "n",
        key = { "<leader>", "d", "O" },
        action = ":lua require'dap'.step_out()<cr>",
        short_desc = "Debug Step Out(F12)",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = { "<F12>" },
        action = ":lua require'dap'.step_out()<cr>",
        short_desc = "Debug Step Out",
        silent = true
    })

    --mappings.register({
    --    mode = "n",
    --    key = { "<leader>", "d", "r" },
    --    action = ":lua require'dap'.repl.open()<cr>",
    --    short_desc = "Debug Repl Open",
    --    silent = true
    --})


end
return plugin
