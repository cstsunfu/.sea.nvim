local plugin = {}

plugin.core = {
    "marko-cerovac/material.nvim",
    as = "material",
    setup = function()  -- Specifies code to run before this plugin is loaded.

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
plugin.setup = function (style)

    vim.cmd("packadd material")

    require('material').setup({
        contrast = {
            sidebars = true, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
            floating_windows = false, -- Enable contrast for floating windows
            line_numbers = false, -- Enable contrast background for line numbers
            sign_column = false, -- Enable contrast background for the sign column
            cursor_line = false, -- Enable darker background for the cursor line
            non_current_windows = false, -- Enable darker background for non-current windows
            popup_menu = false, -- Enable lighter background for the popup menu
        },

        italics = {
            comments = false, -- Enable italic comments
            keywords = false, -- Enable italic keywords
            functions = false, -- Enable italic functions
            strings = false, -- Enable italic strings
            variables = false -- Enable italic variables
        },

        contrast_filetypes = { -- Specify which filetypes get the contrasted (darker) background
            "terminal", -- Darker terminal background
            "packer", -- Darker packer background
            "NvimTree",
            "vista",
            "qf" -- Darker qf list background
        },

        high_visibility = {
            lighter = false, -- Enable higher contrast text for lighter style
            darker = false -- Enable higher contrast text for darker style
        },

        disable = {
            borders = true, -- Disable borders between verticaly split windows
            background = false, -- Prevent the theme from setting the background (NeoVim then uses your teminal background)
            term_colors = false, -- Prevent the theme from setting terminal colors
            eob_lines = false -- Hide the end-of-buffer lines
        },

        lualine_style = "stealth", -- Lualine style ( can be 'stealth' or 'default' )

        async_loading = true, -- Load parts of the theme asyncronously for faster startup (turned on by default)

        custom_highlights = {
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
    local timer = vim.loop.new_timer()
    timer:start(500, 0, vim.schedule_wrap(function()
        vim.cmd("hi! default link WhichKeyFloat Pmenu")
        vim.cmd("hi! default link NormalFloat Pmenu")

        vim.cmd("hi! DiffDelete guibg=#A6647A")
        vim.cmd("hi FgCocWarningFloatBgCocFloating ctermfg=130 guibg=#434c5e ctermbg=13 guifg=#ff922b")
        vim.cmd("hi FgCocErrorFloatBgCocFloating ctermfg=9 ctermbg=13 guibg=#434c5e guifg=#ff0000")
        vim.cmd("hi FgCocHintFloatBgCocFloating guibg=#434c5e ctermbg=13 ctermfg=11 guifg=#fab005")
    end))
end

return plugin
