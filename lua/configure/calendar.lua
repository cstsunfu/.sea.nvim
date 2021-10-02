local plugin = {}

plugin.core = {
    "git@github.com:itchyny/calendar.vim.git",
    as = "calendar",
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        vim.g.calendar_google_calendar = 1
        vim.g.calendar_google_task = 1
        vim.cmd("source ~/.cache/calendar.vim/credentials.vim")
    end,
}

plugin.mapping = function()

end
return plugin
