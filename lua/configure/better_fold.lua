local plugin = {}

plugin.core = {
    "scr1pt0r/crease.vim",
    --    dependencies = {{'airblade/vim-gitgutter'}},
    init = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        --vim.g.crease_foldtext = { default = " %l lines %f%f%t%=%{gitgutter#fold#is_changed() ? ' ' : ''}%=" }
        vim.g.crease_foldtext = {
            --default = "  %l lines %f%f  %t%= ",
            indent = '%{repeat(" ", shiftwidth() * v:foldlevel)}➤ %l lines %f%f %t %f'
        }
    end,

}

plugin.mapping = function()

end
return plugin
