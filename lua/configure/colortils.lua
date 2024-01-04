local plugin = {}

plugin.core = {
    "max397574/colortils.nvim",
    cmd = "Colortils",
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("colortils").setup({
            -- Register in which color codes will be copied
            register = "+",
            -- Preview for colors, if it contains `%s` this will be replaced with a hex color code of the color
            color_preview = "█ %s",
            -- The default in which colors should be saved
            -- This can be hex, hsl or rgb
            default_format = "hex",
            -- Border for the float
            border = "rounded",
            -- Some mappings which are used inside the tools
            mappings = {
                -- increment values
                increment = "l",
                -- decrement values
                decrement = "h",
                -- increment values with bigger steps
                increment_big = "L",
                -- decrement values with bigger steps
                decrement_big = "H",
                -- set values to the minimum
                min_value = "0",
                -- set values to the maximum
                max_value = "$",
                -- save the current color in the register specified above with the format specified above
                set_register_default_format = "<cr>",
                -- save the current color in the register specified above with a format you can choose
                set_register_cjoose_format = "g<cr>",
                -- replace the color under the cursor with the current color in the format specified above
                replace_default_format = "<m-cr>",
                -- replace the color under the cursor with the current color in a format you can choose
                replace_choose_format = "g<m-cr>",
                -- export the current color to a different tool
                export = "E",
                -- set the value to a certain number (done by just entering numbers)
                set_value = "c",
                -- toggle transparency
                transparency = "T",
                -- choose the background (for transparent colors)
                choose_background = "B",
            },
        })
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
    mappings.register({
        mode = "n",
        key = { "<leader>", "c", "n" },
        action = ":Colortils picker #777777<cr>",
        short_desc = "Color New",
        silent = true,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "c", "p" },
        action = ":Colortils picker<cr>",
        short_desc = "Color Picker",
        silent = true,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "c", "s" },
        action = ":Colortils css list<cr>",
        short_desc = "Color Select(CSS)",
        silent = true,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "c", "g" },
        action = ":Colortils gradient ",
        short_desc = "Color Gradient 2 Colors",
        silent = true,
    })
end
return plugin
