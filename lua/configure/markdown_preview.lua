local plugin = {}

plugin.core = {
    "iamcco/markdown-preview.nvim",
    --as = "markdown-preview.nvim",
    run = [[sh -c 'cd app && yarn install']],

    setup = function()  -- Specifies code to run before this plugin is loaded.
        vim.g.mkdp_markdown_css = vim.g.CONFIG..'/lua/util/markdown.css'
    end,

    config = function() -- Specifies code to run after this plugin is loaded
    end,
}

plugin.mapping = function()

    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = {"<leader>", "f", "e"},
        action = ':MarkdownPreview<cr>',
        short_desc = "Markdown Preview",
        silent = true
    })

end
return plugin
