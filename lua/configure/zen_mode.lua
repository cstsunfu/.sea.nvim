local plugin = {}

plugin.core = {
    "folke/zen-mode.nvim",
    as = "zen-mode",
    cmd = { "ZenMode" },
    setup = function() -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        local util = require('zen-mode.util')
        local normal = util.get_hl("Normal")
        local line_nr = util.get_hl("LineNr")
        local backdrop = 0.7
        require("zen-mode").setup {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            window = {
                backdrop = backdrop, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
                -- height and width can be:
                -- * an absolute number of cells when > 1
                -- * a percentage of the width / height of the editor when <= 1
                -- * a function that returns the width or the height
                width = 0.72, -- width of the Zen window
                height = 0.90, -- height of the Zen window
                -- by default, no options are changed for the Zen window
                -- uncomment any of the options below, or add other vim.wo options you want to apply
                options = {
                    -- signcolumn = "no", -- disable signcolumn
                    number = true, -- disable number column
                    relativenumber = true, -- disable relative numbers
                    cursorline = true, -- disable cursorline
                    cursorcolumn = false, -- disable cursor column
                    foldcolumn = "0", -- disable fold column
                    list = false, -- disable whitespace characters
                },
            },
            plugins = {
                -- disable some global vim options (vim.o...)
                -- comment the lines to not apply the options
                options = {
                    enabled = true,
                    ruler = false, -- disables the ruler text in the cmd line area
                    showcmd = false, -- disables the command in the last line of the screen
                },
                twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
                gitsigns = { enabled = false }, -- disables git signs
                tmux = { enabled = false }, -- disables the tmux statusline
                -- this will change the font size on kitty when in zen mode
                -- to make this work, you need to set the following kitty options:
                -- - allow_remote_control socket-only
                -- - listen_on unix:/tmp/kitty
                kitty = {
                    enabled = false,
                    font = "+4", -- font size increment
                },
            },
            -- callback where you can add custom code when the Zen window opens
            on_open = function(win)
                if vim.g.style ~= "light" then
                    local norm_bg = util.darken(normal.background, 0.5 + backdrop / 2)
                    vim.cmd(("highlight Normal guibg=%s guifg=%s"):format(norm_bg, normal.foreground))
                    local nr_bg = util.darken(line_nr.background, 0.5 + backdrop / 2)
                    vim.cmd(("highlight LineNr guibg=%s guifg=%s"):format(nr_bg, line_nr.foreground))
                end
            end,
            -- callback where you can add custom code when the Zen window closes
            on_close = function()
                if vim.g.style ~= "light" then
                    vim.cmd(("highlight Normal guibg=%s guifg=%s"):format(normal.background, normal.foreground))
                    vim.cmd(("highlight LineNr guibg=%s guifg=%s"):format(line_nr.background, line_nr.foreground))
                end
            end,
        }
    end,
}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = { "<leader>", "t", "o" },
        action = ':ZenMode<cr>',
        short_desc = "Toggle Only Window(ZenMode)",
        silent = true
    })

end

return plugin
