local plugin = {}

plugin.core = {
    "rlane/pounce.nvim",
    setup = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require'pounce'.setup{
            accept_keys = "JFKDLHUMNOIPTVGBE",
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
end

return plugin
