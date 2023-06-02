local plugin = {}

plugin.core = {
    "gcmt/wildfire.vim",
    init = function()  -- Specifies code to run before this plugin is loaded.
        vim.g.wildfire_objects = {
            ["*"] = {"iw", "i'", 'i"', "i)", "i]", "i}", "ip", "it"},
            ["html,xml"] = {"at", "it"}
        }

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        -- lua, default settings
    end,
}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = {"n", "v"},
        key = { "<cr>" },
        action = '<Plug>(wildfire-fuel)',
        short_desc = "Auto Select Span",
        noremap = true,
        silent = true,
    })
    mappings.register({
        mode = {"v"},
        key = { "u" },
        action = '<Plug>(wildfire-water)',
        short_desc = "Auto Select Span Previous",
        noremap = true,
        silent = true,
    })

end

return plugin
