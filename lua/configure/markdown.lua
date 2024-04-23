local plugin = {}

plugin.core = {
    "plasticboy/vim-markdown",
    dependencies = {
        -- toggle checkbox
        { "nfrid/markdown-togglecheck" },
        { "nfrid/treesitter-utils" },
        -- add table of content
        { "mzlogin/vim-markdown-toc" },
    },
    ft = { "markdown", "vimwiki" },
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("markdown-togglecheck").setup({
            -- create empty checkbox on item without any while toggling
            create = true,
            -- remove checked checkbox instead of unckecking it while toggling
            remove = true,
        })

        vim.g.vim_markdown_folding_disabled = 1
        vim.g.vim_markdown_conceal = 1
        vim.g.vim_markdown_frontmatter = 1
        vim.g.vim_markdown_conceal_code_blocks = 0
        vim.g.tex_conceal = ""
        vim.g.vim_markdown_math = 1
        vim.g.vim_markdown_new_list_item_indent = 4
        vim.g.vim_markdown_no_extensions_in_markdown = 1
        vim.g.vim_markdown_no_default_key_mappings = 1
        vim.g.vim_markdown_toc_autofit = 1

        local global_func = require("util.global")
        global_func.augroup("Markdown Map", {
            {
                events = { "Filetype" },
                targets = { "markdown" },
                command = "nnoremap <buffer><silent> = V:HeaderIncrease<cr><esc>",
            },
            {
                events = { "Filetype" },
                targets = { "markdown" },
                command = "vnoremap <buffer><silent> = :HeaderIncrease<cr><esc>",
            },
            {
                events = { "Filetype" },
                targets = { "markdown" },
                command = "vnoremap <buffer><silent> - :HeaderDecrease<cr><esc>",
            },
            {
                events = { "Filetype" },
                targets = { "markdown" },
                command = "nnoremap <buffer><silent> - V:HeaderDecrease<cr><esc>",
            },
            {
                events = { "Filetype" },
                targets = { "markdown" },
                command = "nnoremap <buffer><silent> <localleader>o :Toc<cr>",
            },
            {
                events = { "Filetype" },
                targets = { "markdown" },
                command = "nnoremap <buffer><silent> <localleader>O :TOC<cr>",
            },

            {
                events = { "Filetype" },
                targets = { "markdown", "vimwiki" },
                command = "nnoremap <buffer><silent> <C-Enter> :lua require('markdown-togglecheck').toggle()<cr>",
            },
            {
                events = { "Filetype" },
                targets = { "markdown", "vimwiki" },
                command = "nnoremap <buffer><silent> <localleader>l :call vimwiki#lst#toggle_list_item()<cr><esc>",
            },
        })
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
    _G.markdown_follow_link = function()
        local file_path = vim.fn.expand("%:p:h", nil, nil)
        local i, j = string.find(file_path, "MyKB")
        if j ~= nil then
            vim.cmd("ObsidianFollowLink")
        else
            vim.cmd("normal vi(")
            vim.cmd("visual")
            vim.cmd([[execute "normal \<Plug>Markdown_EditUrlUnderCursor"]])
        end
    end
    mappings.register({
        mode = { "n" },
        key = { "g", "e" },
        action = ":lua _G.markdown_follow_link()<cr>",
        short_desc = "Follow Link",
    })
end

return plugin
