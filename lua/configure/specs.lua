local plugin = {}

plugin.core = {
    "edluffy/specs.nvim",
    dependencies = {},
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        vim.cmd("highlight SpecsH guibg=#c43963")
        require("specs").setup({
            show_jumps = false,
            min_jump = 3,
            popup = {
                delay_ms = 0, -- delay before popup displays
                inc_ms = 3, -- time increments used for fade/resize effects
                blend = 40, -- starting blend, between 0-100 (fully transparent), see :h winblend
                width = 18,
                winhl = "SpecsH",
                fader = require("specs").empty_fader,
                resizer = require("specs").shrink_resizer,
            },
            ignore_filetypes = {},
            ignore_buftypes = {
                nofile = true,
            },
        })
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
    mappings.register({
        mode = "n",
        key = { " ", " " },
        action = ':echo |lua require("specs").show_specs()<cr>',
        short_desc = "Blink Cursor",
        silent = true,
    })
end
return plugin
