local plugin = {}

plugin.core = {
    'scr1pt0r/crease.vim',
    --requires = {{'airblade/vim-gitgutter'}},
    setup = function()  -- Specifies code to run before this plugin is loaded.
        --vim.o.foldcolumn = 0
        --vim.o.foldlevelstart = 0
        --" 'space' is fold char ↓

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        --vim.g.crease_foldtext = { default = " %l lines %f%f%t%=%{gitgutter#fold#is_changed() ? ' ' : ''}%=" }
        vim.g.crease_foldtext = { default = " %l lines %f%f  %t%=" }
    end,

}

plugin.mapping = function()

end
return plugin
