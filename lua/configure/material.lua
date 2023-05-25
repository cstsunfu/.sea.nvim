local plugin = {}
local global = require "util.global"

plugin.core = {
    "marko-cerovac/material.nvim",
    as = "material",
    setup = function() -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
    end,
}

plugin.mapping = function()

end

plugin.light = {

}

plugin.dark = {

}
plugin.setup = function(style)

    vim.cmd("packadd material")


    local colors   = require "material.colors"
    colors = require "material.colors.conditionals"
    local m = colors.main
    local e = colors.editor
    local g = colors.git
    local l = colors.lsp
    local s = colors.syntax
    local b = colors.backgrounds
    require('material').setup({
        contrast = {
            sidebars = true, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
            floating_windows = false, -- Enable contrast for floating windows
            line_numbers = false, -- Enable contrast background for line numbers
            sign_column = false, -- Enable contrast background for the sign column
            cursor_line = false, -- Enable darker background for the cursor line
            non_current_windows = false, -- Enable darker background for non-current windows
            popup_menu = false, -- Enable lighter background for the popup menu
            filetypes = vim.g.side_filetypes
        },

        styles = { -- Give comments style such as bold, italic, underline etc.
            comments = { italic = false },
            strings = { --[[ bold = true ]] },
            keywords = { --[[ underline = true ]] },
            functions = { --[[ bold = true, undercurl = true ]] },
            variables = {},
            operators = {},
            types = {},
        },
        plugins = { -- Uncomment the plugins that you use to highlight them
            -- Available plugins:
            "dap",
            "dashboard",
            "gitsigns",
            -- "hop",
            -- "indent-blankline",
            -- "lspsaga",
            -- "mini",
            -- "neogit",
            -- "nvim-cmp",
            -- "nvim-navic",
            "nvim-tree",
            -- "sneak",
            "telescope",
            "trouble",
            "which-key",
        },

        high_visibility = {
            lighter = false, -- Enable higher contrast text for lighter style
            darker = false -- Enable higher contrast text for darker style
        },

        disable = {
            colored_cursor = false, -- Disable the colored cursor
            borders = true, -- Disable borders between verticaly split windows
            background = false, -- Prevent the theme from setting the background (NeoVim then uses your terminal background)
            term_colors = false, -- Prevent the theme from setting terminal colors
            eob_lines = true -- Hide the end-of-buffer lines
        },

        --lualine_style = "stealth", -- Lualine style ( can be 'stealth' or 'default' )
        lualine_style = "default", -- Lualine style ( can be 'stealth' or 'default' )

        async_loading = true, -- Load parts of the theme asyncronously for faster startup (turned on by default)

        custom_highlights = {
            --WinSeparator = { link = "NormalContrast" },
            DapUINormal = { link = "NormalContrast" },
            DapUIValue = { link = "NormalContrast" },
            DapUIVariable = { link = "NormalContrast" },
            DapUIFrameName = { link = "NormalContrast" },
            TSType        = { fg = s.type },
            TSTypeBuiltin = { fg = s.type },

            TSVariableBuiltin = { link = "Identifier" },
            TSField           = { fg = e.fg_dark },
            TSSymbol          = { fg = m.yellow },

            TSFuncBuiltin = { fg = s.fn },
            TSFuncMacro   = { link = "Function" },
            TSConstructor = { link = "Function" },

            TSKeyword = { fg = m.cyan },

            TSConstant        = { fg = m.yellow },
            TSConstantBuiltin = { fg = m.yellow },
            TSConstantMacro   = { fg = m.cyan },

            TSMacro     = { fg = m.cyan },
            TSNamespace = { fg = m.yellow },

            TSStringEscape  = { fg = e.fg_dark },
            TSStringRegex   = { fg = m.yellow },
            TSStringSpecial = { fg = e.fg_dark },

            TSPunct          = { fg = m.cyan },
            TSPunctDelimiter = { fg = m.cyan },
            TSPunctBracket   = { fg = e.title },
            TSURI            = { fg = e.link },
            TSTag            = { fg = m.red },
            TSTagDelimiter   = { fg = m.cyan },
            TSTagAttribute   = { fg = m.purple },
            TSTodo           = { fg = colors.yellow },
            TSString         = { link = "String" },
            TSBoolean         = { link = "Boolean" },
            TSMethod         = { link = "Function" },
            TSFunction         = { link = "Function" },
            TSProperty     = { fg = "#717cb4" },
            TSNumber       = { fg = "#f78c6c" },
            TSOperator     = { fg = "#89ddff" }
            --TSProperty     = { fg = "#717cb4" }
            --TSURI          xxx guifg=#80cbc4
            --TSType         xxx guifg=#c792ea
            --TSFunction     xxx links to Function
            --Function       xxx guifg=#82aaff
            --TSNamespace    xxx guifg=#ffcb6b
            --TSMethod       xxx links to Function
            --TSSymbol       xxx guifg=#ffcb6b
            --TSConstructor  xxx guifg=#82aaff
            --TSNumber       xxx guifg=#f78c6c
            --TSTag          xxx guifg=#f07178
            --TSConstant     xxx links to Constant
            --TSString       xxx links to String
            --Constant       xxx guifg=#ffcb6b
            --TSBoolean      xxx links to Boolean
            --Boolean        xxx guifg=#f78c6c
            --TSOperator     xxx guifg=#89ddff
        } -- Overwrite highlights with your own
    })



    if vim.g.style == "light" then
        vim.g.material_style = 'lighter'
    elseif vim.g.style == "oceanic" then
        vim.g.material_style = 'oceanic'
    elseif vim.g.style == 'palenight' then
        vim.g.material_style = 'palenight'
    elseif vim.g.style == 'deep ocean' then
        vim.g.material_style = 'deep ocean'
    else
        vim.g.material_style = 'darker'
    end
    vim.cmd 'colorscheme material'
    vim.cmd("hi clear Cursor")

    local timer = vim.loop.new_timer()
    timer:start(vim.g.after_schedule_time_start + 100, 0, vim.schedule_wrap(function()
        vim.cmd("hi! default link WhichKeyFloat Pmenu")
        --vim.cmd("hi! default link NormalFloat Pmenu")
        vim.cmd("hi! StatusLine ctermfg=black guifg=black") --set HSplit color to black
        -- FIXED: FIXED: the VertSplit is renamed to WinSeparator https://github.com/marko-cerovac/material.nvim/issues/91 ,
        vim.o.fillchars = "fold:-,eob: ,vert: ,diff: "   -- fillchars , fold for fold fillchars, eob for the end file begin fillchars, vert for vert split
        vim.cmd("hi! DiffDelete guibg=#A6647A")
    end))
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = { "<leader>", "c", "<tab>" },
        action = ":lua require('material.functions').toggle_style()<cr>",
        short_desc = "ColorStyle Exchange",
        silent = true
    })
end

return plugin
