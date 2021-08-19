local plugin = {}

plugin.core = {
    "rcarriga/nvim-dap-ui",
    requires = {"mfussenegger/nvim-dap"},
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
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
                open_on_start = true,
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
                width = 40,
                position = "left", -- Can be "left" or "right"
            },
            tray = {
                open_on_start = true,
                elements = { "repl" },
                height = 10,
                position = "bottom", -- Can be "bottom" or "top"
            },
            floating = {
                max_height = nil, -- These can be integers or a float between 0 and 1.
                max_width = nil, -- Floats will be treated as percentage of your screen.
            },
            windows = { indent = 1 },
        })
    end,

}

plugin.mapping = function()


end
return plugin
