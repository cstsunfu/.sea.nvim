local plugin = {}

plugin.core = {
    "plasticboy/vim-markdown",
    --require = {'godlygeek/tabular'},
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        vim.g.vim_markdown_conceal_code_blocks = 0
        vim.g.tex_conceal = ""
        vim.g.vim_markdown_math = 1
        vim.g.vim_markdown_new_list_item_indent = 4
        vim.g.vim_markdown_no_extensions_in_markdown = 1
        vim.g.vim_markdown_no_default_key_mappings = 1
    end,
}

plugin.mapping = function()
    local mappings = require('core.mapping')
    _G.markdown_follow_link = function()
        local file_path = vim.fn.expand('%:p:h', nil, nil)
        local i, j = string.find(file_path, "MyKB")
        if j ~= nil then
            vim.cmd("ObsidianFollowLink")
        else
            vim.cmd("normal vi(")
            vim.cmd("visual")
            vim.cmd[[execute "normal \<Plug>Markdown_EditUrlUnderCursor"]]
        end
    end
    mappings.register({
        mode = {"v", "n"},
        key = { 'g', 'e' },
        action = ":lua _G.markdown_follow_link()<cr>",
        short_desc = "Follow Link"
    })
end

return plugin
