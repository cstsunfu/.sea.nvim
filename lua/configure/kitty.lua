local plugin = {}

plugin.core = {
    "mikesmithgh/kitty-scrollback.nvim",
    cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth', 'KittyScrollbackGenerateCommandLineEditing' },

    lazy = true,
    event = { 'User KittyScrollbackLaunch' },
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require('kitty-scrollback').setup()
    end,
}

plugin.mapping = function() end
return plugin
