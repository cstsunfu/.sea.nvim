local plugin = {}

plugin.core = {
    "vimwiki/vimwiki",
    --as = "vimwiki",
    setup = function()  -- Specifies code to run before this plugin is loaded.
        vim.g.vimwiki_map_prefix = '<leader>o'
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        vim.cmd("let g:vimwiki_list = [{'path': $HOME.'/org/', 'syntax': 'markdown', 'ext': '.md'}]")
    end,
}

plugin.mapping = function()

end

return plugin
