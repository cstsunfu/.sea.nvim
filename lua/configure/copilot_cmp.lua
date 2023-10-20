local plugin = {}

plugin.core = {
    "zbirenbaum/copilot-cmp",
    dependencies = { "copilot.lua", event='VeryLazy',
        config = function()
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
        end
    },
    event = "InsertEnter",
    init = function() -- Specifies code to run before this plugin is loaded.

    end,

    config = function ()
        require("copilot_cmp").setup({
            formatters = {
                label = require("copilot_cmp.format").format_label_text,
                --insert_text = require("copilot_cmp.format").format_insert_text,
                insert_text = require("copilot_cmp.format").remove_existing,
                preview = require("copilot_cmp.format").deindent,
            }
        })
    end
}

plugin.mapping = function()
end

return plugin
