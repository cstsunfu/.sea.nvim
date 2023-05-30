local plugin = {}

plugin.core = {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    setup = function() -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("copilot").setup({
            suggestion = { enabled = false },
            panel = { enabled = false },
            filetypes = {
                --yaml = false,
                --markdown = false,
                help = false,
                gitcommit = false,
                gitrebase = false,
                hgcommit = false,
                svn = false,
                cvs = false,
                ["."] = false,
            },
        })
    end,
}

plugin.mapping = function()
end

return plugin
