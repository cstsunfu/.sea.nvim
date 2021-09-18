local plugin = {}

plugin.core = {
    "git@github.com:iamcco/markdown-preview.nvim.git",
    as = "markdown-preview.nvim",
    run = [[sh -c 'cd app && yarn install']],

    setup = function()  -- Specifies code to run before this plugin is loaded.

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
