local plugin = {}

plugin.core = {
    --"git@github.com:chipsenkbeil/distant.nvim.git",
    "git@github.com:zenbro/mirror.vim.git",
    as = "mirror.vim",
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
    end,
}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = {"<leader>", "r", "e"},
        action = ':MirrorEdit<cr>',
        short_desc = "Remote Edit",
        silent = true
    })

    mappings.register({
        mode = "n",
        key = {"<leader>", "r", "c"},
        action = ':MirrorConfig<cr>',
        short_desc = "Remote Configure",
        silent = true
    })


end

return plugin
