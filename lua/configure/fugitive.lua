local plugin = {}

plugin.core = {
    "git@github.com:tpope/vim-fugitive.git",
    as = "vim-fugitive",
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
    end,
}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = {"<leader>", "G", "a"},
        action = ':Git add .<cr>',
        short_desc = "Git Add",
        noremap = true,
    })
    mappings.register({
        mode = "n",
        key = {"<leader>", "G", "b"},
        action = ':Git blame<cr>',
        short_desc = "Git Blame",
        silent = true,
        noremap = true,
    })

    mappings.register({
        mode = "n",
        key = {"<leader>", "G", "c"},
        action = ':Git commit<cr>',
        short_desc = "Git Commits",
        silent = true,
        noremap = true,
    })

    mappings.register({
        mode = "n",
        key = {"<leader>", "G", "e"},
        action = ':Gedit ',
        short_desc = "Git Edit Something",
        silent = true,
        noremap = true,
    })

    mappings.register({
        mode = "n",
        key = {"<leader>", "G", "d"},
        action = ':Gdiff<cr>',
        short_desc = "Git Diff",
        silent = true,
        noremap = true,
    })

    mappings.register({
        mode = "n",
        key = {"<leader>", "G", "g"},
        action = ':Ggrep ',
        short_desc = "Git Grep",
        silent = true,
        noremap = true,
    })

    mappings.register({
        mode = "n",
        key = {"<leader>", "G", "l"},
        action = ':Gclog<cr>',
        short_desc = "Git Log",
        silent = true,
        noremap = true,
    })
    mappings.register({
        mode = "n",
        key = {"<leader>", "G", "m"},
        action = ':GMove ',
        short_desc = "Git Move",
        silent = true,
        noremap = true,
    })

    mappings.register({
        mode = "n",
        key = {"<leader>", "G", "r"},
        action = ':Gread<cr>',
        short_desc = "Git Read",
        silent = true,
        noremap = true,
    })
    mappings.register({
        mode = "n",
        key = {"<leader>", "G", "s"},
        action = ':Git<cr>',
        short_desc = "Git Status",
        silent = true,
        noremap = true,
    })
    mappings.register({
        mode = "n",
        key = {"<leader>", "G", "w"},
        action = ':Gwrite<cr>',
        short_desc = "Git Write",
        silent = true,
        noremap = true,
    })
end

return plugin
