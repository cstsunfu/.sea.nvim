local plugin = {}

plugin.core = {
    "kristijanhusak/orgmode.nvim",
    setup = function()  -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require('orgmode').setup{
            org_agenda_files = {'~/org/agenda/*'},
            org_default_notes_file = '~/org/refile.org',
        }
    end,
}

plugin.mapping = function()
end

return plugin
