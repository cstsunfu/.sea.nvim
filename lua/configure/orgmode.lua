local plugin = {}

plugin.core = {
    "kristijanhusak/orgmode.nvim",
    --event = "VeryLazy",
    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require("orgmode").setup_ts_grammar()
        require("orgmode").setup({
            org_agenda_files = { "~/org/agenda/*.org", "~/org/work/weekly/todo.org" },
            org_default_notes_file = "~/org/agenda/refile.org",
            org_todo_keywords = { "TODO(t)", "WAIT", "|", "DONE", "ASSIGN", "CANCEL" },
            org_todo_keyword_faces = {
                TODO = ":foreground #FA7F08 :weight bold",   -- overrides builtin color for `TODO` keyword
                WAIT = ":foreground #F24405 :weight bold",
                DONE = ":foreground #9EF8EE :weight bold",   -- overrides builtin color for `TODO` keyword
                ASSIGN = ":foreground #22BABB :weight bold",
                CANCEL = ":foreground #348888 :weight bold", -- overrides builtin color for `TODO` keyword
            },
            org_deadline_warning_days = 7,
            org_agenda_min_height = 16,
            org_agenda_span = "week",   -- day/week/month/year/number of days
            org_agenda_start_on_weekday = 1,
            org_agenda_start_day = nil, -- start from today + this modifier
            org_capture_templates = {
                t = {
                    description = "Default TODO",
                    template = "** TODO %?\n   SCHEDULED: %T\n   [[file:~/org/wiki/note/;.md]]",
                    target = "~/org/agenda/todo.org",
                },
                w = {
                    description = "Work Weekly Plan",
                    template =
                    "** TODO %?\n   SCHEDULED: %T\n   [[file:~/org/work/weekly/%<%Y>/%<%Y>_%<%W>.md][%<%Y>_%<%W>]]",
                    target = "~/org/work/weekly/todo.org",
                },
            },
            org_agenda_skip_scheduled_if_done = false,
            org_agenda_skip_deadline_if_done = false,
            org_agenda_text_search_extra_files = {},
            org_priority_highest = "A",
            org_priority_default = "B",
            org_priority_lowest = "C",
            org_archive_location = "%s_archive::",
            org_use_tag_inheritance = true,
            org_tags_exclude_from_inheritance = {},
            org_hide_leading_stars = false,
            org_hide_emphasis_markers = false,
            org_ellipsis = "...",
            org_log_done = "time",
            org_highlight_latex_and_related = nil,
            org_custom_exports = {},
            org_indent_mode = "indent",
            org_time_stamp_rounding_minutes = 5,
            org_blank_before_new_entry = {
                heading = true,
                plain_list_item = false,
            },
            org_src_window_setup = "top 20new",
            org_edit_src_content_indentation = 0,
            diagnostics = true,
            notifications = {
                enabled = false,
                cron_enabled = true,
                repeater_reminder_time = { 1, 10 },
                deadline_warning_reminder_time = false,
                reminder_time = 10,
                deadline_reminder = true,
                scheduled_reminder = true,
                notifier = function(tasks)
                    local result = {}
                    for _, task in ipairs(tasks) do
                        require("orgmode.utils").concat(result, {
                            string.format("# %s (%s)", task.category, task.humanized_duration),
                            string.format("%s %s %s", string.rep("*", task.level), task.todo, task.title),
                            string.format("%s: <%s>", task.type, task.time:to_string()),
                        })
                    end

                    if not vim.tbl_isempty(result) then
                        require("orgmode.notifications.notification_popup"):new({ content = result })
                    end
                end,
                cron_notifier = function(tasks)
                    for _, task in ipairs(tasks) do
                        local title = string.format("%s (%s)", task.category, task.humanized_duration)
                        local subtitle = string.format("%s %s %s", string.rep("*", task.level), task.todo, task.title)
                        local date = string.format("%s: %s", task.type, task.time:to_string())
                        -- Linux
                        if vim.fn.executable("notify-send") == 1 then
                            vim.loop.spawn(
                                "notify-send",
                                { args = { string.format("%s\n%s\n%s", title, subtitle, date) } }
                            )
                        elseif vim.fn.executable("terminal-notifier") == 1 then -- MacOS
                            vim.loop.spawn(
                                "terminal-notifier",
                                { args = { "-title", title, "-subtitle", subtitle, "-message", date } }
                            )
                        end
                    end
                end,
            },
            mappings = {
                disable_all = false,
                global = {
                    org_agenda = "<leader>oa",
                    org_capture = "<leader>oc",
                },
                agenda = {
                    org_agenda_later = "f",
                    org_agenda_earlier = "b",
                    org_agenda_goto_today = ".",
                    org_agenda_day_view = "vd",
                    org_agenda_week_view = "vw",
                    org_agenda_month_view = "vm",
                    org_agenda_year_view = "vy",
                    org_agenda_quit = "q",
                    org_agenda_switch_to = "<CR>",
                    org_agenda_goto = { "<TAB>" },
                    org_agenda_goto_date = "J",
                    org_agenda_redo = "r",
                    org_agenda_todo = "t",
                    org_agenda_clock_goto = "<leader>oxj",
                    org_agenda_set_effort = "<leader>oxe",
                    org_agenda_clock_in = "I",
                    org_agenda_clock_out = "O",
                    org_agenda_clock_cancel = "X",
                    org_agenda_clockreport_mode = "R",
                    org_agenda_priority = "<leader>o,",
                    org_agenda_priority_up = "+",
                    org_agenda_priority_down = "-",
                    org_agenda_toggle_archive_tag = "<leader>oA",
                    org_agenda_set_tags = "<leader>ot",
                    org_agenda_deadline = "<leader>oid",
                    org_agenda_schedule = "<leader>ois",
                    org_agenda_filter = "/",
                    org_agenda_show_help = "g?",
                },
                capture = {
                    org_capture_finalize = "<C-c>",
                    org_capture_refile = "<leader>or",
                    org_capture_kill = "<leader>ok",
                    org_capture_show_help = "g?",
                },
                org = {
                    org_refile = "<leader>or",
                    org_timestamp_up_day = "<S-UP>",
                    org_timestamp_down_day = "<S-DOWN>",
                    org_timestamp_up = "<C-a>",
                    org_timestamp_down = "<C-x>",
                    org_change_date = "cid",
                    --org_priority = '<leader>o,',
                    org_priority_up = "ciR",
                    org_priority_down = "cir",
                    org_todo = "cit",
                    org_todo_prev = "ciT",
                    --org_toggle_checkbox = '<C-Space>',
                    --org_toggle_heading = '<leader>o*',
                    org_open_at_point = "<leader>of",
                    --org_edit_special = [[<leader>o']],
                    org_cycle = "<TAB>",
                    org_global_cycle = "<S-TAB>",
                    org_archive_subtree = "<leader>o$",
                    org_set_tags_command = "<leader>ot",
                    org_toggle_archive_tag = "<leader>oA",
                    org_do_promote = "<<",
                    org_do_demote = ">>",
                    org_promote_subtree = "<s",
                    org_demote_subtree = ">s",
                    org_meta_return = "<leader><CR>",                        -- Add headling, item or row
                    org_insert_heading_respect_content = "<leader>oih",      -- Add new headling after current heading block with same level
                    org_insert_todo_heading = "<leader>oiT",                 -- Add new todo headling right after current heading with same level
                    org_insert_todo_heading_respect_content = "<leader>oit", -- Add new todo headling after current heading block on same level
                    org_move_subtree_up = "<leader>oK",
                    org_move_subtree_down = "<leader>oJ",
                    org_export = "<leader>oe",
                    org_next_visible_heading = "}",
                    org_previous_visible_heading = "{",
                    org_forward_heading_same_level = "]]",
                    org_backward_heading_same_level = "[[",
                    outline_up_heading = "g{",
                    org_deadline = "<leader>oid",
                    org_schedule = "<leader>ois",
                    org_time_stamp = "<leader>oi.",
                    org_time_stamp_inactive = "<leader>oi,",
                    org_clock_in = "<leader>oxi",
                    org_clock_out = "<leader>oxo",
                    org_clock_cancel = "<leader>oxq",
                    org_clock_goto = "<leader>oxj",
                    org_set_effort = "<leader>oxe",
                    org_show_help = "g?",
                },
                edit_src = {
                    org_edit_src_abort = "<leader>ok",
                    org_edit_src_save = "<leader>ow",
                    org_edit_src_show_help = "g?",
                },
                text_objects = {
                    inner_heading = "ih",
                    around_heading = "ah",
                    inner_subtree = "ir",
                    around_subtree = "ar",
                    inner_heading_from_root = "Oh",
                    around_heading_from_root = "OH",
                    inner_subtree_from_root = "Or",
                    around_subtree_from_root = "OR",
                },
            },
            emacs_config = {
                executable_path = "emacs",
                config_path = "$HOME/.emacs.d/init.el",
            },
        })
        vim.cmd([[autocmd FileType org setlocal iskeyword+=:,#,+]])
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
    mappings.register({
        mode = "n",
        key = { "<leader>", "o", "a" },
        action = nil,
        short_desc = "Org Agenda",
        silent = false,
    })

    mappings.register({
        mode = "n",
        key = { "<leader>", "o", "c" },
        action = nil,
        short_desc = "Org Capture",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "o", "x" },
        action = nil,
        short_desc = "Org Clock",
        silent = true,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "o", "x", "e" },
        action = nil,
        short_desc = "Org Effort Estimate",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "o", "x", "i" },
        action = nil,
        short_desc = "Clock In",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "o", "x", "o" },
        action = nil,
        short_desc = "Clock Out",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "o", "x", "q" },
        action = nil,
        short_desc = "Clock Cancel",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "o", "x", "j" },
        action = nil,
        short_desc = "Clock Goto",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "c", "i", "r" },
        action = nil,
        short_desc = "Org Priority Down",
        silent = false,
    })
    mappings.register({
        mode = { "n", "x" },
        key = { "c", "i", "R" },
        action = nil,
        short_desc = "Org Priority Up",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "c", "i", "t" },
        action = nil,
        short_desc = "Org Todo Status",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "c", "i", "T" },
        action = nil,
        short_desc = "Org Todo Status",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "c", "i", "d" },
        action = nil,
        short_desc = "Org Change Date",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "o", "f" },
        action = nil,
        short_desc = "Org Open File",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "o", "t" },
        action = nil,
        short_desc = "Org Tag",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "o", "i" },
        action = nil,
        short_desc = "Org Insert",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "o", "i", "d" },
        action = nil,
        short_desc = "Org Insert DEADLINE",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "o", "i", "h" },
        action = nil,
        short_desc = "Org Insert Headline",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "o", "i", "s" },
        action = nil,
        short_desc = "Org Insert SCHEDULED",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "o", "i", "t" },
        action = nil,
        short_desc = "Org Insert TODO",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "o", "i", "." },
        action = nil,
        short_desc = "Org Insert Time Stamp",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "o", "i", "T" },
        action = nil,
        short_desc = "Org Inplace Insert TODO",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "o", "i", "," },
        action = nil,
        short_desc = "Org Insert Inactive Time Stamp",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "o", "K" },
        action = nil,
        short_desc = "Org Move Up",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "o", "J" },
        action = nil,
        short_desc = "Org Move Down",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "o", "'" },
        action = nil,
        short_desc = "Org Edit Source",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "o", "$" },
        action = nil,
        short_desc = "Org Archive Subtree",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "o", "A" },
        action = nil,
        short_desc = "Org Archive Tag",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "o", "r" },
        action = nil,
        short_desc = "Org Refile To",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "o", "*" },
        action = nil,
        short_desc = "Org Toggle Headline",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "o", "," },
        action = nil,
        short_desc = "Org Priority",
        silent = false,
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "o", "e" },
        action = nil,
        short_desc = "Org Export(Emacs)",
        silent = false,
    })
end

return plugin
