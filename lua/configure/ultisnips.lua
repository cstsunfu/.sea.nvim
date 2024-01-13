local plugin = {}
plugin.core = {
    "SirVer/ultisnips",
    event = "InsertEnter",
    init = function() -- Specifies code to run before this plugin is loaded.
        vim.g.UltiSnipsExpandTrigger = "<C-j>"
        vim.g.UltiSnipsEditSplit = "vertical"
        vim.g.UltiSnipsListSnippets = "<c-x><c-s>"
        vim.g.UltiSnipsRemoveSelectModeMappings = 0
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        vim.g.UltiSnipsJumpForwardTrigger = "<c-j>"
        vim.g.UltiSnipsJumpBackwardTrigger = "<c-k>"
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
    mappings.register({
        mode = "n",
        key = { "<leader>", "s", "e" },
        action = ":UltiSnipsEdit<cr>",
        short_desc = "Test ot",
        silent = true,
    })
end
return plugin
