local plugin = {}

plugin.core = {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("notify").setup({
            background_colour = "#000000",
            top_down = false,
        })
        local banned_messages = { "No information available" }
        vim.notify = function(msg, ...)
            for _, banned in ipairs(banned_messages) do
                if msg == banned then
                    return
                end
            end
            return require("notify")(msg, ...)
        end
    end,
}

plugin.mapping = function() end
return plugin
