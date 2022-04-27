local plugin = {}

plugin.core = {
    "liuchengxu/vista.vim",
    as = "vista",
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded

        -- How each level is indented and what to prepend.
        -- This could make the display more compact or more spacious.
        -- e.g., more compact: ["▸ ", ""]
        -- Note: this option only works for the kind renderer, not the tree renderer.
        --vim.g.vista_icon_indent = {"╰─▸ ", "├─▸ "}
        vim.g.vista_icon_indent = {}

        -- Executive used when opening vista sidebar without specifying it.
        -- See all the avaliable executives via `:echo g:vista#executives`.
        vim.g.vista_default_executive = 'coc'

        -- Set the executive for some filetypes explicitly. Use the explicit executive
        -- instead of the default one for these filetypes when using `:Vista` without
        -- specifying the executive.

        -- To enable fzf's preview window set g:vista_fzf_preview.
        -- The elements of g:vista_fzf_preview will be passed as arguments to fzf#vim#with_preview()
        -- For example:
        --vim.g.vista_fzf_preview = {'right:30%'}
        vim.g.vista_sidebar_position = "vertical topleft"
        vim.g.vista_sidebar_width = 36
        vim.g.vista_disable_statusline = true
        --vim.g["vista#renderer#icons"] = {}
        vim.g.vista_enable_markdown_extension = 0
        vim.cmd([[
            let g:vista#renderer#icons = { "function": "  ", "functions": "  ", "variable": "  ", "variables": "  ", "maps": "  ", "members ": "  ", "classes": "  ", "autocommand groups": " 祐 "}
        ]])

    end,
}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = {"<leader>", "t", "l"},
        action = ':Vista!!<cr>',
        short_desc = "Tag List",
        silent = true
    })

end

return plugin
