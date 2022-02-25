local plugin = {}

plugin.core = {
    "dyng/ctrlsf.vim",
    as = "ctrlsf",
    cmd = 'CtrlSF',
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded

    end,

}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = {"<leader>", "s", "f"},
        action = ':CtrlSF<cr>',
        short_desc = "Search Current Word",
        silent = true
    })

end
return plugin
