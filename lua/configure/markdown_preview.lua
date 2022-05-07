local plugin = {}

plugin.core = {
    "iamcco/markdown-preview.nvim",
    --as = "markdown-preview.nvim",
    run = "cd app && yarn install",
    --cmd = "MarkdownPreview",

    setup = function() -- Specifies code to run before this plugin is loaded.
    end,


    config = function() -- Specifies code to run after this plugin is loaded
        vim.g.mkdp_markdown_css = vim.g.CONFIG .. '/lua/util/markdown.css'
    end,
}

plugin.mapping = function()

    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = { "<leader>", "f", "e" },
        action = ':MarkdownPreviewToggle<cr>',
        short_desc = "Markdown Preview",
        silent = true
    })

end
return plugin
