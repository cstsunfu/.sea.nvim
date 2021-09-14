local plugin = {}

plugin.core = {
    "git@github.com:mbbill/undotree.git",
    as = "undotree",
    cmd='UndotreeToggle',
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded

    end,

}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = {"<leader>", "h", "t"},
        action = ':UndotreeToggle<cr>',
        short_desc = "History Tree",
        silent = true
    })

end
return plugin
