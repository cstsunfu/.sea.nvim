local plugin = {}

plugin.core = {
    "jbyuki/nabla.nvim",
    ft = { "vimwiki", "markdown" },
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
    mappings.register({
        mode = "n",
        key = { "<localleader>", "f" },
        action = ":lua require('nabla').popup({border='rounded'})<CR>",
        short_desc = "Display Formula",
    })
end

return plugin
