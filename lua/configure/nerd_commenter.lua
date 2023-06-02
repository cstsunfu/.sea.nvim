local plugin = {}

plugin.core = {
    "preservim/nerdcommenter",
    init = function() -- Specifies code to run before this plugin is loaded.
        vim.g.NERDCreateDefaultMappings = 0
        vim.g.NERDCustomDelimiters = {
            json = {
                left='// '
            },
            json5 = {
                left='// '
            },
            hjson = {
                left='// '
            },
         }
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
        key = { "<leader>", "c", "x" },
        action = "<Plug>NERDCommenterAltDelims",
        short_desc = "Comment Exchange Format",
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
