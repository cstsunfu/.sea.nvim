local plugin = {}
plugin.core = {
    "SirVer/ultisnips",
    --as = "ultisnips",
    setup = function()  -- Specifies code to run before this plugin is loaded.
        vim.g.UltiSnipsEditSplit = 'vertical'
        vim.g.snips_author = 'Sun Fu'
        vim.g.snips_email = 'cstsunfu@gmail.com'
        vim.g.snips_github = 'https://github.com/cstsunfu'
        vim.g.snips_wechat = 'cstsunfu'
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        vim.g.UltiSnipsExpandTrigger="<leader><tab>"
        --vim.g:UltiSnipsJumpForwardTrigger="<c-j>"
        --vim.g:UltiSnipsJumpBackwardTrigger="<c-k>"
    end,

}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = {"<leader>", "s", "e"},
        action = ":UltiSnipsEdit<cr>",
        short_desc = "Test ot",
        silent = true
    })

end
return plugin
