local plugin = {}

plugin.core = {
    "itchyny/calendar.vim",
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        vim.g.calendar_google_calendar = 1
        vim.g.calendar_google_task = 1
    end,
}

plugin.mapping = function()

end
return plugin
