local plugin = {}

plugin.core = {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    main = "ibl",
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        local highlight = {
            "RainbowBlue",
            "RainbowViolet",
            "RainbowOrange",
            "RainbowGreen",
            "RainbowCyan",
            "RainbowRed",
            "RainbowYellow",
        }

        local hooks = require("ibl.hooks")
        -- create the highlight groups in the highlight setup hook, so they are reset
        -- every time the colorscheme changes
        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
            vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
            vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
            vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
            vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
            vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
            vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
            vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        end)

        require("ibl").setup({
            indent = { char = "│", priority = 20 },
            whitespace = {
                remove_blankline_trail = false,
            },
            exclude = {
                filetypes = {
                    "translator",
                    "dapui_breakpoints",
                    "dapui_watches",
                    "dapui_stacks",
                    "dapui_scopes",
                    "",
                    "help",
                    "packer",
                    "startify",
                    "dashboard",
                    "vimwiki",
                    "markdown",
                    "calendar",
                },
                buftypes = { "terminal" },
            },
            scope = {
                enabled = true,
                show_start = false,
                show_end = false,
                injected_languages = false,
                highlight = highlight,
                priority = 500,
            },
        })
    end,
}
plugin.mapping = function()
    local mappings = require("core.mapping")
end
return plugin
