local plugin = {}

plugin.core = {
    'nat-418/boole.nvim',
    setup = function() -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require('boole').setup({
            mappings = {
                increment = '<C-a>',
                decrement = '<C-x>'
            },
            -- User defined loops
            additions = {
                {'Foo', 'Bar'},
            },
            allow_caps_additions = {
                {'enable', 'disable'}
                -- enable → disable
                -- Enable → Disable
                -- ENABLE → DISABLE
            }
        })
    end,
}

plugin.mapping = function()
end

return plugin
