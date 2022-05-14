local plugin = {}

plugin.core = {
    "tpope/vim-fugitive",
    as = "fugitive",
    cmd = { "Git", "Gedit", "Gdiff", "Ggrep", "Gclog", "GMove", "Gread", "Gwrite" },
    setup = function() -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
    end,
}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = { "<leader>", "g", "a" },
        action = ':Git add .<cr>',
        short_desc = "Git Add",
        noremap = true,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "g", "b" },
        action = ':Git blame<cr>',
        short_desc = "Git Blame",
        silent = true,
        noremap = true,
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "g", "c" },
        action = ':Git commit<cr>',
        short_desc = "Git Commits",
        silent = true,
        noremap = true,
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "g", "C" },
        action = ':Git checkout ',
        short_desc = "Git Checkout",
        silent = false,
        noremap = true,
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "g", "e" },
        action = ':Gedit ',
        short_desc = "Git Edit Something",
        silent = false,
        noremap = true,
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "g", "d" },
        action = ':Gdiff<cr>',
        short_desc = "Git Diff",
        silent = true,
        noremap = true,
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "g", "g" },
        action = ':Ggrep ',
        short_desc = "Git Grep",
        silent = true,
        noremap = true,
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "g", "l" },
        action = ':0Gclog<cr>',
        short_desc = "Git Log For Current File",
        silent = true,
        noremap = true,
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "g", "L" },
        action = ':Gclog<cr>',
        short_desc = "Git Log",
        silent = true,
        noremap = true,
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "g", "m" },
        action = ':GMove ',
        short_desc = "Git Move",
        silent = true,
        noremap = true,
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "g", "r" },
        action = ':Gread<cr>',
        short_desc = "Git Read",
        silent = true,
        noremap = true,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "g", "s" },
        action = ':Git<cr>',
        short_desc = "Git Status",
        silent = true,
        noremap = true,
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "g", "w" },
        action = ':Gwrite<cr>',
        short_desc = "Git Write",
        silent = true,
        noremap = true,
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "g", "u" },
        action = ':Git pull<cr>',
        short_desc = "Git Pull",
        silent = true,
        noremap = true,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "g", "p" },
        action = ':Git push<cr>',
        short_desc = "Git Push",
        silent = true,
        noremap = true,
    })
end

return plugin
