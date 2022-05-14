local plugin = {}

plugin.core = {
    'edluffy/specs.nvim',
    requires = {
    },
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded

        vim.cmd('highlight SpecsH guibg=#99ddee')
        require('specs').setup{
            show_jumps  = true,
            min_jump = 3,
            popup = {
                delay_ms = 0, -- delay before popup displays
                inc_ms = 8, -- time increments used for fade/resize effects
                blend = 0, -- starting blend, between 0-100 (fully transparent), see :h winblend
                width = 18,
                winhl = "SpecsH",
                fader = require('specs').empty_fader,
                resizer = require('specs').shrink_resizer
            },
            ignore_filetypes = {},
            ignore_buftypes = {
                nofile = true,
            },
        }
    end,

}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = {" ", " "},
        action = ':lua require("specs").show_specs()<cr>',
        short_desc = "Blink Cursor",
        silent = true
    })
end
return plugin
