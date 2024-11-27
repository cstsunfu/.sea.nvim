local plugin = {}

plugin.core = {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("neoscroll").setup({
            -- All these keys will be mapped to their corresponding default scrolling animation
            hide_cursor = true, -- Hide cursor while scrolling
            stop_eof = true, -- Stop at <EOF> when scrolling downwards
            use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
            respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
            cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
            easing_function = nil, -- Default easing function
            pre_hook = nil, -- Function to run before the scrolling animation starts
            post_hook = nil, -- Function to run after the scrolling animation ends
            easing = "quadratic",
        })
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
    local keymaps = {}
    local neoscroll = require("neoscroll")
    local keymap = {
        -- Use the "sine" easing function
        ["<C-u>"] = function()
            neoscroll.ctrl_u({ duration = 100, easing = "sine" })
        end,
        ["<C-d>"] = function()
            neoscroll.ctrl_d({ duration = 100, easing = "sine" })
        end,
        -- Use the "circular" easing function
        ["<C-b>"] = function()
            neoscroll.ctrl_b({ duration = 150, easing = "circular" })
        end,
        ["<C-f>"] = function()
            neoscroll.ctrl_f({ duration = 150, easing = "circular" })
        end,
        -- When no value is passed the `easing` option supplied in `setup()` is used
        ["<C-y>"] = function()
            neoscroll.scroll(-0.1, { move_cursor = false, duration = 30 })
        end,
        ["<C-e>"] = function()
            neoscroll.scroll(0.1, { move_cursor = false, duration = 30 })
        end,
        ["zt"] = function()
            neoscroll.zt({ half_win_duration = 50 })
        end,
        ["zz"] = function()
            neoscroll.zz({ half_win_duration = 50 })
        end,
        ["zb"] = function()
            neoscroll.zb({ half_win_duration = 50 })
        end,
    }
    for key, func in pairs(keymaps) do
        mappings.register({
            mode = { "n", "v", "x" },
            key = key,
            action = func,
            short_desc = "Scroll",
        })
    end
end
return plugin
