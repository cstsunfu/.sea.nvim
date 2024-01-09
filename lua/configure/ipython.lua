local plugin = {}

plugin.core = {
    "jupyter-vim/jupyter-vim",
    ft = { "python" },
    init = function() -- Specifies code to run before this plugin is loaded.
        vim.g.jupyter_highlight_cells = 0
        vim.g.jupyter_mapkeys = 0
    end,

    config = function() -- Specifies code to run after this plugin is loaded
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
    mappings.register({
        mode = "n",
        key = { "<leader>", "j", "r" },
        action = ":!jupyter qtconsole&<cr>",
        short_desc = "Jupyter Run",
        silent = true,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "j", "." },
        action = ":JupyterCd %:p:h<CR>",
        short_desc = "Jupyter Change Dir to Current",
        silent = true,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "j", "c" },
        action = ":JupyterConnect<CR>",
        short_desc = "Jupyter Connect",
        silent = true,
    })
    mappings.register({
        mode = "v",
        key = { "<localleader>", "e" },
        action = ":JupyterSendRange<cr>",
        short_desc = "Jupyter Run Visual",
        silent = true,
    })
    mappings.register({
        mode = "n",
        key = { "<localleader>", "e" },
        action = ":JupyterSendCount<cr>",
        short_desc = "Jupyter Run Current Line",
        silent = true,
    })
end

return plugin
