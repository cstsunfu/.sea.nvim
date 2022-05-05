local plugin = {}

plugin.core = {

    "skywind3000/asynctasks.vim",
    as = "asynctasks",
    cmd = { "AsyncTask" },

    requires = { {
        "skywind3000/asyncrun.vim",
        as = "asyncrun",
    }
    },

    setup = function() -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        if not packer_plugins['asyncrun'].loaded then
            vim.cmd [[packadd asyncrun]]
        end
        vim.g.asynctasks_extra_config = { vim.g.CONFIG .. 'tasks.ini' }
        vim.g.asyncrun_open = 8
        vim.g.asyncrun_bell = 1

    end,
}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = { "<leader>", "q", "b" },
        action = "<cmd>AsyncTask file-build<cr>",
        short_desc = "Quick Build",
        silent = true,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "q", "r" },
        action = "<cmd>AsyncTask file-run<cr>",
        short_desc = "Quick Run",
        silent = true,
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "q", "g" },
        action = nil,
        short_desc = "Quick Grep",
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "q", "g", "c" },
        action = "<cmd>AsyncTask quickfix-rg-grep<cr>",
        short_desc = "Quick Grep Current Path",
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "q", "g", "p" },
        action = "<cmd>AsyncTask quickfix-rg-grep-project<cr>",
        short_desc = "Quick Grep Project Path",
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "q", "g", "f" },
        action = "<cmd>AsyncTask quickfix-rg-grep-filetype<cr>",
        short_desc = "Quick Grep Current Path File Types",
    })


end
return plugin
