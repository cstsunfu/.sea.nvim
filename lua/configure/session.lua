local plugin = {}

plugin.core = {
    "nvimdev/dbsession.nvim",
    cmd = { 'SessionSave', 'SessionDelete', 'SessionLoad'},
    setup = function()  -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require('dbsession').setup({})
    end,
}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = {"<leader>", "s", "k"},
        action = ':SessionSave ',
        short_desc = "Session Keep",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = {"<leader>", "s", "L"},
        action = ':SessionLoad ',
        short_desc = "Session List",
        silent = true
    })
    mappings.register({
        mode = "n",
        key = {"<leader>", "s", "d"},
        action = ':SessionDelete ',
        short_desc = "Session Delete",
        silent = true
    })

end

return plugin
