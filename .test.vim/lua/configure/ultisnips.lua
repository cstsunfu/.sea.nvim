local plugin = {}
plugin.core = {
    'SirVer/ultisnips',
    setup = function()  -- Specifies code to run before this plugin is loaded.
        vim.g.UltiSnipsEditSplit = 'vertical'
        vim.g.snips_author = 'Sun Fu'
        vim.g.snips_email = 'cstsunfu@gmail.com'
        vim.g.snips_github = 'https://github.com/cstsunfu'
        vim.g.snips_wechat = 'cstsunfu'
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        --vim.g.UltiSnipsExpandTrigger="<leader><tab>"
        --vim.g:UltiSnipsJumpForwardTrigger="<c-j>"
        --vim.g:UltiSnipsJumpBackwardTrigger="<c-k>"
    end,

}

plugin.mapping = function()

end
return plugin
