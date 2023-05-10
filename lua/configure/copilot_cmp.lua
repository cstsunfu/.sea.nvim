local plugin = {}

plugin.core = {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    setup = function() -- Specifies code to run before this plugin is loaded.

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
