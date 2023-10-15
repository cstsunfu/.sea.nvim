local plugin = {}

plugin.core = {
    "cstsunfu/pounce-zh.nvim",
    cmd = { "Pounce" },
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require'pounce'.setup{
            accept_keys = "JFKDLSHGYTURIEOWPQBNVCMXZ102948576;',.",
            accept_best_key = "<enter>",
            multi_window = true,
            debug = false,
        }
    end
}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = { "<leader>", "<space>" },
        action = '<cmd>Pounce<CR>',
        short_desc = "Easy Jumpy",
        silent = true
    })
    mappings.register({
        mode = {'n'},
        key = { "s" },
        action = '<cmd>Pounce<CR>',
        short_desc = "Easy Jumpy",
        silent = true
    })

    mappings.register({
        mode = {'v'},
        key = { "<C-f>" },
        action = '<cmd>Pounce<CR>',
        short_desc = "Easy Jumpy",
        silent = true
    })
end

return plugin
