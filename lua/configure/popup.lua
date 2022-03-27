local plugin = {}

plugin.core = {
    "nvim-lua/popup.nvim",
    opt = true,
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
    end,
}

plugin.mapping = function()
end

return plugin
