local plugin = {}

local pomodoro = require("hack.pomodoro")
local lualine_file_name_cache = {}
local lualine_inactive_file_name_cache = {}
local lualine_proj_name_cache = {}
local lualine_tmux_sess_cache = {}
local lualine_buf_size_cache = {}

local lualine_win_display_condition_cache = {}

plugin.core = {
    "nvim-lualine/lualine.nvim",
    event = "ColorScheme",
    init = function() -- Specifies code to run before this plugin is loaded.
        local aug = vim.api.nvim_create_augroup("lualine_new_file", { clear = true })
        vim.api.nvim_create_autocmd({ "BufEnter", "VimResized", "WinNew", "WinClosed" }, {
            callback = function()
                lualine_file_name_cache = {}
                lualine_inactive_file_name_cache = {}
                lualine_proj_name_cache = {}
                lualine_tmux_sess_cache = {}
                lualine_buf_size_cache = {}
                lualine_win_display_condition_cache = {}
            end,
            group = aug,
            pattern = "*",
        })

        vim.g._current_time = os.date("%H:%M")
        local timer = vim.loop.new_timer()
        timer:start(
            1000,
            15000,
            vim.schedule_wrap(function()
                vim.g._current_time = os.date("%H:%M")
                vim.cmd("redrawstatus")
            end)
        )
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        local lualine = require("lualine")
        local Path = require("plenary.path")
        local root = Path:new("/")
        local root_patterns = {
            ".git",
            "setup.py",
            "setup.cfg",
            "pyproject.toml",
            "requirements.txt",
            ".svn",
            ".root",
            ".project",
            ".hg",
            "__main__.py",
        }

        local home_path = Path:new(vim.g.HOME_PATH)
        local custom_theme = require("lualine.themes.auto")
        local global_fun = require("util.global")
        if vim.g.colorscheme_name == "material_light" then
            custom_theme.normal.c.bg = "#e7e7e8"
            custom_theme.normal.c.fg = "#383653"
            custom_theme.inactive.c.bg = "#e7e7e8"
            custom_theme.inactive.c.fg = "#384653"
        else
            custom_theme.normal.c.bg = global_fun.brighten(custom_theme.normal.c.bg, -5)
            custom_theme.inactive.c.bg = custom_theme.normal.c.bg
        end
        -- Color table for highlights
        local colors = {
            fg = custom_theme.normal.c.fg,
            bg = custom_theme.normal.c.bg,
            yellow = "#ECBE7B",
            cyan = "#008080",
            darkblue = "#081633",
            green = "#98be65",
            orange = "#FF8800",
            violet = "#a9a1e1",
            magenta = "#c678dd",
            blue = "#51afef",
            dark_blue = global_fun.brighten("#51afef", -5),
            red = "#ec5f67",
            inactive = "#808080",
            gray = "#808080",
        }

        local not_only_win_num = function()
            local only_win_num_filetyps = {
                ["NvimTree"] = true,
                ["vista"] = true,
                ["Outline"] = true,
                ["vista_markdown"] = true,
                ["vista_kind"] = true,
                ["ctrlsf"] = true,
                ["undotree"] = true,
                ["diff"] = true,
                ["dapui_stacks"] = true,
                ["dapui_breakpoints"] = true,
                ["dapui_watches"] = true,
                ["dapui_scopes"] = true,
                ["dap-repl"] = true,
                ["DiffviewFiles"] = true,
            }
            local only_win_num_buffertype = {
                ["terminal"] = true,
            }
            return not only_win_num_filetyps[vim.bo.filetype] and not only_win_num_buffertype[vim.bo.buftype]
        end

        local buffer_not_empty = function()
            return vim.fn.empty(vim.fn.expand("%:t", nil, nil)) ~= 1
        end
        local dap_ui_map = { -- dapui
            ["dapui_stacks"] = "Stack",
            ["dapui_breakpoints"] = "BreakPoint",
            ["dapui_watches"] = "Watch",
            ["dapui_scopes"] = "Scope",
            ["dap-repl"] = "Repl",
        }

        local handle = io.popen("tmux display-message -p '#S' 2>&1")
        local result = handle:read("*a")
        if string.find(result, "not found") then
            vim.g.tmux_ready = false
        else
            if string.find(result, "no server running") then
                vim.g.tmux_ready = false
            else
                vim.g.tmux_ready = true
            end
        end
        local conditions = {
            terminal_condition = function()
                local win_id = vim.fn.winnr()
                if lualine_win_display_condition_cache[win_id] == nil then
                    lualine_win_display_condition_cache[win_id] = {}
                end
                if lualine_win_display_condition_cache["terminal_condition"] == nil then
                    lualine_win_display_condition_cache["terminal_condition"] = vim.bo.buftype == "terminal"
                        and vim.fn.winwidth(vim.fn.winnr()) > 30
                end
                return lualine_win_display_condition_cache["terminal_condition"]
            end,
            dapui_condition = function() -- dapui
                local win_id = vim.fn.winnr()
                if lualine_win_display_condition_cache[win_id] == nil then
                    lualine_win_display_condition_cache[win_id] = {}
                end
                if lualine_win_display_condition_cache[win_id]["dapui_condition"] == nil then
                    lualine_win_display_condition_cache[win_id]["dapui_condition"] = dap_ui_map[vim.bo.filetype] ~= nil
                        and vim.fn.winwidth(vim.fn.winnr()) > 30
                end
                return lualine_win_display_condition_cache[win_id]["dapui_condition"]
            end,
            limit_active_file_name_in_width = function()
                local win_id = vim.fn.winnr()
                if lualine_win_display_condition_cache[win_id] == nil then
                    lualine_win_display_condition_cache[win_id] = {}
                end
                if lualine_win_display_condition_cache[win_id]["limit_active_file_name_in_width"] == nil then
                    lualine_win_display_condition_cache[win_id]["limit_active_file_name_in_width"] = vim.fn.winwidth(0)
                        > 185
                end
                return lualine_win_display_condition_cache[win_id]["limit_active_file_name_in_width"]
            end,
            nest_active_file_name_in_width = function()
                local win_id = vim.fn.winnr()
                if lualine_win_display_condition_cache[win_id] == nil then
                    lualine_win_display_condition_cache[win_id] = {}
                end
                if lualine_win_display_condition_cache[win_id]["nest_active_file_name_in_width"] == nil then
                    lualine_win_display_condition_cache[win_id]["nest_active_file_name_in_width"] = vim.fn.winwidth(0)
                        > 165
                end
                return lualine_win_display_condition_cache[win_id]["nest_active_file_name_in_width"]
            end,
            limit_inactive_file_name_in_width = function()
                local win_id = vim.fn.winnr()
                if lualine_win_display_condition_cache[win_id] == nil then
                    lualine_win_display_condition_cache[win_id] = {}
                end
                if lualine_win_display_condition_cache[win_id]["limit_inactive_file_name_in_width"] == nil then
                    lualine_win_display_condition_cache[win_id]["limit_inactive_file_name_in_width"] = vim.fn.winwidth(
                        0
                    ) > 150
                end
                return lualine_win_display_condition_cache[win_id]["limit_inactive_file_name_in_width"]
            end,
            nest_inactive_file_name_in_width = function()
                local win_id = vim.fn.winnr()
                if lualine_win_display_condition_cache[win_id] == nil then
                    lualine_win_display_condition_cache[win_id] = {}
                end
                if lualine_win_display_condition_cache[win_id]["nest_inactive_file_name_in_width"] == nil then
                    lualine_win_display_condition_cache[win_id]["nest_inactive_file_name_in_width"] = vim.fn.winwidth(0)
                        > 120
                end
                return lualine_win_display_condition_cache[win_id]["nest_inactive_file_name_in_width"]
            end,
            hide_encoding_in_width = function()
                local win_id = vim.fn.winnr()
                if lualine_win_display_condition_cache[win_id] == nil then
                    lualine_win_display_condition_cache[win_id] = {}
                end
                if lualine_win_display_condition_cache[win_id]["hide_encoding_in_width"] == nil then
                    lualine_win_display_condition_cache[win_id]["hide_encoding_in_width"] = not_only_win_num()
                        and vim.fn.winwidth(vim.fn.winnr()) > 140
                end
                return lualine_win_display_condition_cache[win_id]["hide_encoding_in_width"]
            end,
            check_git_workspace_hide_in_width = function()
                local win_id = vim.fn.winnr()
                if lualine_win_display_condition_cache[win_id] == nil then
                    lualine_win_display_condition_cache[win_id] = {}
                end
                if lualine_win_display_condition_cache[win_id]["check_git_workspace_hide_in_width"] == nil then
                    local filepath = vim.fn.expand("%:p:h", nil, nil)
                    local gitdir = vim.fn.finddir(".git", filepath .. ";")
                    lualine_win_display_condition_cache[win_id]["check_git_workspace_hide_in_width"] = not_only_win_num()
                        and gitdir
                        and #gitdir > 0
                        and #gitdir < #filepath
                        and vim.fn.winwidth(0) > 145
                end
                return lualine_win_display_condition_cache[win_id]["check_git_workspace_hide_in_width"]
            end,
            hide_diagnostics_in_width = function()
                local win_id = vim.fn.winnr()
                if lualine_win_display_condition_cache[win_id] == nil then
                    lualine_win_display_condition_cache[win_id] = {}
                end
                if lualine_win_display_condition_cache[win_id]["hide_diagnostics_in_width"] == nil then
                    lualine_win_display_condition_cache[win_id]["hide_diagnostics_in_width"] = vim.fn.winwidth(0) > 150
                end
                return lualine_win_display_condition_cache[win_id]["hide_diagnostics_in_width"]
            end,
            nest_project_prefix_in_width = function()
                local win_id = vim.fn.winnr()
                if lualine_win_display_condition_cache[win_id] == nil then
                    lualine_win_display_condition_cache[win_id] = {}
                end
                if lualine_win_display_condition_cache[win_id]["nest_project_prefix_in_width"] == nil then
                    lualine_win_display_condition_cache[win_id]["nest_project_prefix_in_width"] = vim.fn.winwidth(0)
                        > 145
                end
                return lualine_win_display_condition_cache[win_id]["nest_project_prefix_in_width"]
            end,
            hide_project_in_width = function()
                local win_id = vim.fn.winnr()
                if lualine_win_display_condition_cache[win_id] == nil then
                    lualine_win_display_condition_cache[win_id] = {}
                end
                if lualine_win_display_condition_cache[win_id]["hide_project_in_width"] == nil then
                    lualine_win_display_condition_cache[win_id]["hide_project_in_width"] = not_only_win_num()
                        and vim.fn.winwidth(0) > 125
                end
                return lualine_win_display_condition_cache[win_id]["hide_project_in_width"]
            end,
            active_add_wind_in_width = function()
                local win_id = vim.fn.winnr()
                if lualine_win_display_condition_cache[win_id] == nil then
                    lualine_win_display_condition_cache[win_id] = {}
                end
                if lualine_win_display_condition_cache[win_id]["active_add_wind_in_width"] == nil then
                    lualine_win_display_condition_cache[win_id]["active_add_wind_in_width"] = not not_only_win_num()
                        or vim.fn.winwidth(0) <= 125
                end
                return lualine_win_display_condition_cache[win_id]["active_add_wind_in_width"]
            end,
            hide_location_in_width = function()
                local win_id = vim.fn.winnr()
                if lualine_win_display_condition_cache[win_id] == nil then
                    lualine_win_display_condition_cache[win_id] = {}
                end
                if lualine_win_display_condition_cache[win_id]["hide_location_in_width"] == nil then
                    lualine_win_display_condition_cache[win_id]["hide_location_in_width"] = not_only_win_num()
                        and vim.fn.winwidth(0) > 115
                end
                return lualine_win_display_condition_cache[win_id]["hide_location_in_width"]
            end,
            buffer_not_empty_hide_size_in_width = function()
                local win_id = vim.fn.winnr()
                if lualine_win_display_condition_cache[win_id] == nil then
                    lualine_win_display_condition_cache[win_id] = {}
                end
                if lualine_win_display_condition_cache[win_id]["buffer_not_empty_hide_size_in_width"] == nil then
                    lualine_win_display_condition_cache[win_id]["buffer_not_empty_hide_size_in_width"] = not_only_win_num()
                        and buffer_not_empty()
                        and vim.fn.winwidth(vim.fn.winnr()) > 105
                end
                return lualine_win_display_condition_cache[win_id]["buffer_not_empty_hide_size_in_width"]
            end,
            hide_tmux_in_width = function()
                local win_id = vim.fn.winnr()
                if lualine_win_display_condition_cache[win_id] == nil then
                    lualine_win_display_condition_cache[win_id] = {}
                end
                if lualine_win_display_condition_cache[win_id]["hide_tmux_in_width"] == nil then
                    lualine_win_display_condition_cache[win_id]["hide_tmux_in_width"] = vim.g.tmux_ready
                        and not_only_win_num()
                        and vim.fn.winwidth(0) > 90
                end
                return lualine_win_display_condition_cache[win_id]["hide_tmux_in_width"]
            end,
            hide_progress_in_width = function()
                local win_id = vim.fn.winnr()
                if lualine_win_display_condition_cache[win_id] == nil then
                    lualine_win_display_condition_cache[win_id] = {}
                end
                if lualine_win_display_condition_cache[win_id]["hide_progress_in_width"] == nil then
                    lualine_win_display_condition_cache[win_id]["hide_progress_in_width"] = not_only_win_num()
                        and vim.fn.winwidth(0) > 80
                end
                return lualine_win_display_condition_cache[win_id]["hide_progress_in_width"]
            end,
            hide_pomodoro_in_width = function()
                local win_id = vim.fn.winnr()
                if lualine_win_display_condition_cache[win_id] == nil then
                    lualine_win_display_condition_cache[win_id] = {}
                end
                if lualine_win_display_condition_cache[win_id]["hide_pomodoro_in_width"] == nil then
                    lualine_win_display_condition_cache[win_id]["hide_pomodoro_in_width"] = not_only_win_num()
                        and vim.fn.winwidth(0) > 65
                end
                return lualine_win_display_condition_cache[win_id]["hide_pomodoro_in_width"]
            end,
            hide_clock_in_width = function()
                local win_id = vim.fn.winnr()
                if lualine_win_display_condition_cache[win_id] == nil then
                    lualine_win_display_condition_cache[win_id] = {}
                end
                if lualine_win_display_condition_cache[win_id]["hide_clock_in_width"] == nil then
                    lualine_win_display_condition_cache[win_id]["hide_clock_in_width"] = not_only_win_num()
                        and vim.fn.winwidth(0) > 38
                end
                return lualine_win_display_condition_cache[win_id]["hide_clock_in_width"]
            end,
            hide_status_active_in_width = function()
                local win_id = vim.fn.winnr()
                if lualine_win_display_condition_cache[win_id] == nil then
                    lualine_win_display_condition_cache[win_id] = {}
                end
                if lualine_win_display_condition_cache[win_id]["hide_status_active_in_width"] == nil then
                    lualine_win_display_condition_cache[win_id]["hide_status_active_in_width"] = not_only_win_num()
                        and vim.fn.winwidth(0) > 38
                end
                return lualine_win_display_condition_cache[win_id]["hide_status_active_in_width"]
            end,
            buffer_not_empty_hide_file_in_width = function()
                local win_id = vim.fn.winnr()
                if lualine_win_display_condition_cache[win_id] == nil then
                    lualine_win_display_condition_cache[win_id] = {}
                end
                if lualine_win_display_condition_cache[win_id]["buffer_not_empty_hide_file_in_width"] == nil then
                    lualine_win_display_condition_cache[win_id]["buffer_not_empty_hide_file_in_width"] = not_only_win_num()
                        and buffer_not_empty()
                        and vim.fn.winwidth(0) > 80
                end
                return lualine_win_display_condition_cache[win_id]["buffer_not_empty_hide_file_in_width"]
            end,
            inactive_buffer_not_empty_nest_file_in_width = function()
                local win_id = vim.fn.winnr()
                if lualine_win_display_condition_cache[win_id] == nil then
                    lualine_win_display_condition_cache[win_id] = {}
                end
                if
                    lualine_win_display_condition_cache[win_id]["inactive_buffer_not_empty_nest_file_in_width"] == nil
                then
                    lualine_win_display_condition_cache[win_id]["inactive_buffer_not_empty_nest_file_in_width"] = buffer_not_empty()
                        and vim.fn.winwidth(vim.fn.winnr()) > 80
                end
                return lualine_win_display_condition_cache[win_id]["inactive_buffer_not_empty_nest_file_in_width"]
            end,
            inactive_buffer_not_empty_hide_file_in_width = function()
                local win_id = vim.fn.winnr()
                if lualine_win_display_condition_cache[win_id] == nil then
                    lualine_win_display_condition_cache[win_id] = {}
                end
                if
                    lualine_win_display_condition_cache[win_id]["inactive_buffer_not_empty_hide_file_in_width"] == nil
                then
                    lualine_win_display_condition_cache[win_id]["inactive_buffer_not_empty_hide_file_in_width"] = not_only_win_num()
                        and buffer_not_empty()
                        and vim.fn.winwidth(vim.fn.winnr()) > 60
                end
                return lualine_win_display_condition_cache[win_id]["inactive_buffer_not_empty_hide_file_in_width"]
            end,
            inactive_hide_encoding_in_width = function()
                local win_id = vim.fn.winnr()
                if lualine_win_display_condition_cache[win_id] == nil then
                    lualine_win_display_condition_cache[win_id] = {}
                end
                if lualine_win_display_condition_cache[win_id]["inactive_hide_encoding_in_width"] == nil then
                    lualine_win_display_condition_cache[win_id]["inactive_hide_encoding_in_width"] = not_only_win_num()
                        and vim.fn.winwidth(vim.fn.winnr()) > 60
                end
                return lualine_win_display_condition_cache[win_id]["inactive_hide_encoding_in_width"]
            end,
            inactive_hide_wind_in_width = function()
                local win_id = vim.fn.winnr()
                if lualine_win_display_condition_cache[win_id] == nil then
                    lualine_win_display_condition_cache[win_id] = {}
                end
                if lualine_win_display_condition_cache[win_id]["inactive_hide_wind_in_width"] == nil then
                    lualine_win_display_condition_cache[win_id]["inactive_hide_wind_in_width"] = vim.fn.winwidth(0)
                        >= 15
                end
                return lualine_win_display_condition_cache[win_id]["inactive_hide_wind_in_width"]
            end,
            hide_bound_in_width = function()
                local win_id = vim.fn.winnr()
                if lualine_win_display_condition_cache[win_id] == nil then
                    lualine_win_display_condition_cache[win_id] = {}
                end
                if lualine_win_display_condition_cache[win_id]["hide_bound_in_width"] == nil then
                    lualine_win_display_condition_cache[win_id]["hide_bound_in_width"] = vim.fn.winwidth(vim.fn.winnr())
                        > 20
                end
                return lualine_win_display_condition_cache[win_id]["hide_bound_in_width"]
            end,
        }

        -- Config
        local config = {
            options = {
                -- Disable sections and component separators
                component_separators = "",
                theme = custom_theme,
                section_separators = "",
                disabled_filetypes = { "WhichKey", "nofile", "packer" },
            },
            sections = {
                -- these are to remove the defaults
                lualine_a = {},
                lualine_b = {},
                lualine_y = {},
                lualine_z = {},
                -- These will be filled later
                lualine_c = {},
                lualine_x = {},
            },
            inactive_sections = {
                -- these are to remove the defaults
                lualine_a = {},
                lualine_v = {},
                lualine_y = {},
                lualine_z = {},
                lualine_c = {},
                lualine_x = {},
            },
        }
        local function format_file_size(file)
            local size = vim.fn.getfsize(file)
            if size <= 0 then
                return ""
            end
            local sufixes = { "b", "k", "m", "g" }
            local i = 1
            while size > 1024 do
                size = size / 1024
                i = i + 1
            end
            return string.format("%.1f%s", size, sufixes[i])
        end

        local function insert_target(target, component)
            table.insert(target, component)
        end

        -- Inserts a component in lualine_c at left section
        local function ins_left_active(component)
            insert_target(config.sections.lualine_c, component)
        end

        -- Inserts a component in lualine_x ot right section
        local function ins_right_active(component)
            insert_target(config.sections.lualine_x, component)
        end

        ins_left_active({
            function()
                return "▌"
            end,
            color = { fg = colors.blue }, -- Sets highlighting of component
            padding = { left = 0 },
            cond = conditions.hide_bound_in_width,
        })

        ins_left_active({
            -- mode component
            function()
                -- auto change color according to neovims mode
                local mode_color = {
                    n = colors.red,
                    i = colors.green,
                    v = colors.blue,
                    [""] = colors.blue,
                    V = colors.blue,
                    [""] = colors.blue,
                    c = colors.magenta,
                    no = colors.red,
                    s = colors.orange,
                    S = colors.orange,
                    [""] = colors.orange,
                    ic = colors.yellow,
                    R = colors.violet,
                    Rv = colors.violet,
                    cv = colors.red,
                    ce = colors.red,
                    r = colors.cyan,
                    rm = colors.cyan,
                    ["r?"] = colors.cyan,
                    ["!"] = colors.red,
                    t = colors.red,
                }
                vim.api.nvim_command("hi! LualineMode guifg=" .. mode_color[vim.fn.mode()] .. " guibg=" .. colors.bg)
                return "  "
                --
            end,
            color = "LualineMode",
            padding = { left = 0 },
            cond = conditions.hide_status_active_in_width,
        })

        ins_left_active({
            -- filesize component
            function()
                local cur_buf = vim.api.nvim_get_current_buf()
                if cur_buf == nil then
                    return ""
                end

                if lualine_buf_size_cache[cur_buf] == nil then
                    local file = vim.fn.expand("%:p")
                    if string.len(file) == 0 then
                        return ""
                    end
                    lualine_buf_size_cache[cur_buf] = format_file_size(file)
                end
                return lualine_buf_size_cache[cur_buf]
            end,
            cond = conditions.buffer_not_empty_hide_size_in_width,
        })

        ins_left_active({
            function()
                return string.format("%-10s", dap_ui_map[vim.bo.filetype])
            end,
            cond = conditions.dapui_condition,
            color = { fg = colors.blue, gui = "bold" },
        })

        ins_left_active({
            function()
                return string.format("%-10s", "Terminal")
            end,
            cond = conditions.terminal_condition,
            color = { fg = colors.blue, gui = "bold" },
        })

        ins_left_active({
            function()
                local cur_buf = vim.api.nvim_get_current_buf()
                if cur_buf == nil then
                    return ""
                end
                if lualine_file_name_cache[cur_buf] == nil then
                    local fname = vim.fn.getcwd()
                    local path = Path:new(fname)
                    local split_path = path:_split()
                    if not conditions.nest_active_file_name_in_width() then
                        fname = vim.fn.expand("%")
                        if string.len(fname) > 25 then
                            fname = string.sub(fname, 1, 23) .. ".."
                        end
                    elseif not conditions.limit_active_file_name_in_width() then
                        fname = table.concat({ split_path[#split_path], vim.fn.expand("%") }, "/")
                        if string.len(fname) > 30 then
                            --fname = string.sub(fname, 1, 28) .. "..."
                            local fname_len = string.len(fname)
                            fname = ".." .. string.sub(fname, fname_len - 28, fname_len) -- Keep the name except the folder
                        end
                    else
                        fname = table.concat({ split_path[#split_path], vim.fn.expand("%") }, "/")
                        if string.len(fname) > 45 then
                            --fname = string.sub(fname, 1, 28) .. "..."
                            local fname_len = string.len(fname)
                            fname = ".." .. string.sub(fname, fname_len - 43, fname_len) -- Keep the name except the folder
                        end
                    end
                    lualine_file_name_cache[cur_buf] = fname
                end
                return lualine_file_name_cache[cur_buf]
            end,
            cond = conditions.buffer_not_empty_hide_file_in_width,
            color = { fg = colors.magenta, gui = "bold" },
            file_status = true, -- displays file status (readonly status, modified status)
        })

        ins_left_active({
            "location",
            cond = conditions.hide_location_in_width,
        })
        if vim.g.feature_groups.lsp == "coc" then
            ins_left_active({
                "diagnostics",
                sources = { "coc" },
                symbols = { error = " ", warn = " ", info = " ", hint = " " },
                diagnostics_color = {
                    error = { fg = colors.red },
                    warning = { fg = colors.yellow },
                    info = { fg = colors.cyan },
                    hint = { fg = colors.cyan },
                },
                cond = conditions.hide_diagnostics_in_width,
            })
            ins_left_active({
                "g:coc_status",
            })
        else
            ins_left_active({
                "diagnostics",
                sources = { "nvim_lsp" },
                symbols = { error = " ", warn = " ", info = " ", hint = " " },
                color_error = colors.red,
                color_warn = colors.yellow,
                color_info = colors.cyan,
                color_hint = colors.cyan,
                cond = conditions.hide_diagnostics_in_width,
            })
        end
        -- Insert mid section. You can make any number of sections in neovim :)
        -- for lualine it's any number greater then 2
        ins_left_active({
            function()
                return "%="
            end,
        })

        ins_left_active({
            -- Project name .
            function()
                local cur_buf = vim.api.nvim_get_current_buf()
                if cur_buf == nil then
                    return ""
                end
                local project_result = ""
                if lualine_proj_name_cache[cur_buf] == nil then
                    local fname = vim.fn.getcwd()
                    local path = Path:new(fname)
                    local project_name = nil
                    -- for python lib/python3.x/site-packages/
                    local split_path = {}
                    local lib_flag = false
                    for _, value in pairs(path:_split()) do
                        if value == "lib" then
                            lib_flag = true
                        end
                        if lib_flag and value ~= nil and value ~= "" then
                            table.insert(split_path, value)
                        end
                    end
                    if
                        #split_path >= 4
                        and string.find(split_path[2], "python") ~= nil
                        and split_path[3] == "site-packages"
                    then
                        project_name = split_path[4]
                    -- for general case
                    else
                        while
                            (path.filename ~= home_path.filename)
                            and (path.filename ~= root.filename)
                            and (project_name == nil)
                        do
                            for _, pattern in ipairs(root_patterns) do
                                if path:joinpath(pattern):exists() then
                                    split_path = path:_split()
                                    project_name = split_path[#split_path]
                                    break
                                end
                            end
                            path = path:parent()
                        end
                    end

                    local prefix = ""
                    if conditions.nest_project_prefix_in_width() then
                        prefix = "🍀 Project: " -- 
                        --🌊🐶 🍵 ☕ 🌿 🍀
                    else
                        prefix = ""
                    end
                    if project_name ~= nil then
                        if string.len(project_name) > 20 then
                            project_name = string.sub(project_name, 1, 18) .. "..."
                        end
                        project_result = prefix .. project_name
                    else
                        project_result = prefix .. "NOT A NORMAL PROJECT"
                    end
                    lualine_proj_name_cache[cur_buf] = project_result
                    return project_result
                else
                    return lualine_proj_name_cache[cur_buf]
                end
            end,
            icon = "",
            color = { fg = colors.fg },
            cond = conditions.hide_project_in_width,
        })
        ins_left_active({
            function()
                local cur_winnr = vim.fn.winnr()
                local win_display_list = {
                    " ❶ ",
                    " ❷ ",
                    " ❸ ",
                    " ❹ ",
                    " ❺ ",
                    " ❻ ",
                    " ❼ ",
                    " ❽ ",
                    " ❾ ",
                }
                if cur_winnr > #win_display_list then
                    return " "
                end
                return win_display_list[cur_winnr]
            end,
            color = { fg = colors.blue, gui = "bold" }, -- Sets highlighting of component
            padding = { left = 0 },
            cond = conditions.active_add_wind_in_width,
        })

        -- Add components to right sections
        ins_right_active({
            function()
                local cur_buf = vim.api.nvim_get_current_buf()
                if cur_buf == nil then
                    return ""
                end
                if lualine_tmux_sess_cache[cur_buf] == nil then
                    local handle = io.popen("tmux display-message -p '#S' 2>&1")
                    local result = handle:read("*a")
                    local prefix = " "

                    result = result:gsub("%s+", "")
                    if result ~= nil and result ~= "" then
                        if string.len(result) > 12 then
                            result = string.sub(result, 1, 10) .. "..."
                        end
                        result = prefix .. result
                    else
                        result = prefix .. "NOTMUX"
                    end
                    lualine_tmux_sess_cache[cur_buf] = result
                end
                return lualine_tmux_sess_cache[cur_buf]
            end,
            icon = "",
            color = { fg = colors.cyan },
            cond = conditions.hide_tmux_in_width,
        })

        ins_right_active({
            function()
                local display = ""
                display = display .. "DONE " .. tostring(pomodoro.finished_pomo) .. "*"
                return display
            end,
            icon = "",
            color = { fg = colors.magenta },
            cond = conditions.hide_pomodoro_in_width,
        })

        ins_right_active({
            function()
                local display = ""
                if pomodoro.reserve then
                    display = display
                        .. "  "
                        .. string.format("%d", (pomodoro.pomo_minites - pomodoro.reserve) / pomodoro.pomo_minites * 100)
                        .. "%% "
                end
                return display
            end,
            icon = "",
            color = { fg = colors.violet },
        })

        -- Add components to right sections
        ins_right_active({
            "o:encoding", -- option component same as &encoding in viml
            fmt = string.upper, -- I'm not sure why it's upper case either ;)
            cond = conditions.hide_encoding_in_width,
            color = { fg = colors.green, gui = "bold" },
        })

        ins_right_active({
            "branch",
            icon = "",
            cond = conditions.check_git_workspace_hide_in_width,
            color = { fg = colors.violet, gui = "bold" },
        })

        ins_right_active({
            "progress",
            color = { fg = colors.magenta },
            cond = conditions.hide_progress_in_width,
        })

        ins_right_active({
            function()
                return " " .. vim.g._current_time
            end,
            icon = "",
            color = { fg = colors.yellow, gui = "bold" },
            cond = conditions.hide_clock_in_width,
        })

        ins_right_active({
            function()
                return "▐"
            end, --█
            color = { fg = colors.blue },
            padding = { right = 0 },
            cond = conditions.hide_bound_in_width,
        })
        -- Inserts a component in lualine_c at left section
        local function ins_left_inactive(component)
            insert_target(config.inactive_sections.lualine_c, component)
        end

        -- Inserts a component in lualine_x ot right section
        local function ins_right_inactive(component)
            insert_target(config.inactive_sections.lualine_x, component)
        end

        ins_left_inactive({
            function()
                return "▌"
            end, --'▌▊'
            color = { fg = colors.blue }, -- Sets highlighting of component
            padding = { left = 0 },
            cond = conditions.hide_bound_in_width,
        })
        ins_left_inactive({
            -- filesize component
            function()
                local cur_buf = vim.api.nvim_get_current_buf()
                if cur_buf == nil then
                    return ""
                end

                if lualine_buf_size_cache[cur_buf] == nil then
                    local file = vim.fn.expand("%:p")
                    if string.len(file) == 0 then
                        return ""
                    end
                    lualine_buf_size_cache[cur_buf] = format_file_size(file)
                end
                return lualine_buf_size_cache[cur_buf]
            end,
            cond = conditions.buffer_not_empty_hide_size_in_width,
            color = { fg = colors.inactive }, -- Sets highlighting of component
        })

        ins_left_inactive({
            function()
                local cur_buf = vim.api.nvim_get_current_buf()
                if cur_buf == nil then
                    return ""
                end
                if lualine_inactive_file_name_cache[cur_buf] == nil then
                    local fname = vim.fn.getcwd()
                    local path = Path:new(fname)
                    local split_path = path:_split()
                    if not conditions.nest_inactive_file_name_in_width() then
                        fname = vim.fn.expand("%")
                        if string.len(fname) > 12 then
                            fname = string.sub(fname, 1, 10) .. ".."
                        end
                    elseif not conditions.limit_inactive_file_name_in_width() then
                        fname = table.concat({ split_path[#split_path], vim.fn.expand("%") }, "/")
                        if string.len(fname) > 17 then
                            --fname = string.sub(fname, 1, 28) .. "..."
                            local fname_len = string.len(fname)
                            fname = ".." .. string.sub(fname, fname_len - 15, fname_len) -- Keep the name except the folder
                        end
                    else
                        fname = table.concat({ split_path[#split_path], vim.fn.expand("%") }, "/")
                        if string.len(fname) > 32 then
                            --fname = string.sub(fname, 1, 28) .. "..."
                            local fname_len = string.len(fname)
                            fname = ".." .. string.sub(fname, fname_len - 30, fname_len) -- Keep the name except the folder
                        end
                    end
                    lualine_inactive_file_name_cache[cur_buf] = fname
                end
                return lualine_inactive_file_name_cache[cur_buf]
            end,
            cond = conditions.inactive_buffer_not_empty_hide_file_in_width,
            color = { fg = colors.inactive, gui = "bold" },
            file_status = true, -- displays file status (readonly status, modified status)
        })

        ins_left_inactive({ -- dapui
            function()
                return string.format("%-10s", dap_ui_map[vim.bo.filetype])
            end,
            cond = conditions.dapui_condition,
            color = { fg = colors.inactive, gui = "bold" },
        })

        ins_left_inactive({ -- dapui
            function()
                return string.format("%-10s", "Terminal")
            end,
            cond = conditions.terminal_condition,
            color = { fg = colors.inactive, gui = "bold" },
        })

        ins_left_inactive({
            function()
                return "%="
            end,
        })

        ins_left_inactive({
            function()
                local cur_winnr = vim.fn.winnr()
                local win_display_list = {
                    " ❶ ",
                    " ❷ ",
                    " ❸ ",
                    " ❹ ",
                    " ❺ ",
                    " ❻ ",
                    " ❼ ",
                    " ❽ ",
                    " ❾ ",
                }
                if cur_winnr > #win_display_list then
                    return " "
                end
                return win_display_list[cur_winnr]
            end,
            color = { fg = colors.blue, gui = "bold" }, -- Sets highlighting of component
            padding = { left = 0 },
            cond = conditions.inactive_hide_wind_in_width,
        })
        -- Add components to right sections
        ins_right_inactive({
            "o:encoding", -- option component same as &encoding in viml
            fmt = string.upper, -- I'm not sure why it's upper case either ;)
            cond = conditions.inactive_hide_encoding_in_width,
            color = { fg = colors.inactive, gui = "bold" },
        })

        ins_right_inactive({
            "branch",
            icon = "",
            cond = conditions.check_git_workspace_hide_in_width,
            color = { fg = colors.inactive, gui = "bold" },
        })

        ins_right_inactive({
            function()
                return "▐"
            end,
            color = { fg = colors.blue },
            padding = { right = -1 },
            cond = conditions.hide_bound_in_width,
        })

        -- Now don't forget to initialize lualine
        lualine.setup(config)
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
    for i = 1, 9, 1 do
        mappings.register({
            mode = "n",
            key = { "<localleader>", tostring(i) },
            action = tostring(i) .. "<c-w><c-w>",
            short_desc = "Goto " .. tostring(i) .. " Window",
            noremap = true,
            silent = true,
        })
    end
end

return plugin
