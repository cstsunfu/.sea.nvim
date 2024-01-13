local plugin = {}

plugin.core = {
    "karb94/neoscroll.nvim",
    event = "BufEnter",
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("neoscroll").setup({
            -- All these keys will be mapped to their corresponding default scrolling animation
            --mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>',
            --'<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
            hide_cursor = true, -- Hide cursor while scrolling
            stop_eof = true, -- Stop at <EOF> when scrolling downwards
            use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
            respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
            cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
            easing_function = nil, -- Default easing function
            pre_hook = nil, -- Function to run before the scrolling animation starts
            post_hook = nil, -- Function to run after the scrolling animation ends
        })

        local t = {}
        -- Syntax: t[keys] = {function, {function arguments}}
        t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "100", "sine" } }
        t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "100", "quadratic" } }
        t["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "150" } }
        t["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "150" } }
        t["<C-y>"] = { "scroll", { "-0.10", "false", "30" } }
        t["<C-e>"] = { "scroll", { "0.10", "false", "30" } }
        t["zt"] = { "zt", { "50" } }
        t["zz"] = { "zz", { "50" } }
        t["zb"] = { "zb", { "50" } }
        require("neoscroll.config").set_mappings(t)
    end,
}

plugin.mapping = function() end

return plugin
