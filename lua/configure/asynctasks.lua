local plugin = {}

plugin.core = {

    "skywind3000/asynctasks.vim",

    requires = {
        "skywind3000/asyncrun.vim",
    },

    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        if not packer_plugins['asyncrun.vim'].loaded then
            vim.cmd [[packadd asyncrun.vim]]
        end
        vim.g.asynctasks_extra_config = {vim.g.CONFIG..'tasks.ini'}
        vim.g.asyncrun_open = 8
        vim.g.asyncrun_bell = 1

    end,
}

plugin.mapping = function()
    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = {"<leader>", "q", "b"},
        action = "<cmd>AsyncTask file-build<cr>",
        short_desc = "Quick Build",
        silent = true,
    })
    mappings.register({
        mode = "n",
        key = {"<leader>", "q", "r"},
        action = "<cmd>AsyncTask file-run<cr>",
        short_desc = "Quick Run",
        silent = true,
    })


end
return plugin

