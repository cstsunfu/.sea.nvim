local plugin = {}

plugin.core = {
    "preservim/nerdcommenter",
    --as = "nerdcommenter",
    setup = function() -- Specifies code to run before this plugin is loaded.
        vim.g.NERDCreateDefaultMappings = 0
    end,

    config = function() -- Specifies code to run after this plugin is loaded

    end,

}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = { "n", "v" },
        key = { "<leader>", "c", "c" },
        action = "<Plug>NERDCommenterAlignBoth",
        short_desc = "Comment",
        silent = true,
    })
    mappings.register({
        mode = { "n", "v" },
        key = { "<leader>", "c", "a" },
        action = "<Plug>NERDCommenterAltDelims",
        short_desc = "Comment Alt Format",
        silent = true,
    })
    mappings.register({
        mode = { "n", "v" },
        key = { "<leader>", "c", "A" },
        action = "<Plug>NERDCommenterAppend",
        short_desc = "Comment Append",
        silent = true,
    })
    mappings.register({
        mode = { "n", "v" },
        key = { "<leader>", "c", "u" },
        action = "<Plug>NERDCommenterUncomment",
        short_desc = "UnComment",
        silent = true,
    })
end
return plugin
