local plugin = {}

plugin.core = {
    "nvim-lualine/lualine.nvim",
    as = "lualine",
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded

        -- Eviline config for lualine
        -- Author: shadmansaleh
        -- Credit: glepnir
        -- modified: cstsunfu
        if not packer_plugins['plenary.nvim'].loaded then
            vim.cmd [[packadd plenary.nvim]]
        end

        local lualine = require 'lualine'
        local Path = require'plenary.path'
        local root = Path:new("/")
        local root_patterns = {".git", "setup.py", "setup.cfg", "pyproject.toml", "requirements.txt"}
        local home_path = Path:new(vim.g.HOME_PATH)
        local custom_theme = require'lualine.themes.auto'
        local global_fun = require'util.global'
        if vim.g.colorscheme_name == 'material_light' then
            --custom_theme.normal.c.bg = '#e7e7e8'
            custom_theme.normal.c.fg = '#383653'
            --custom_theme.inactive.c.bg = '#e7e7e8'
            custom_theme.inactive.c.fg = '#384653'
        end
        if vim.g.colorscheme == 'material' then
            custom_theme.normal.c.bg = global_fun.get_highlight_values("Pmenu").background
            custom_theme.inactive.c.bg = global_fun.get_highlight_values("Pmenu").background
        end
        -- Color table for highlights
        local colors = {
            fg = custom_theme.normal.c.fg,
            bg = custom_theme.normal.c.bg,
            yellow = '#ECBE7B',
            cyan = '#008080',
            darkblue = '#081633',
            green = '#98be65',
            orange = '#FF8800',
            violet = '#a9a1e1',
            magenta = '#c678dd',
            blue = '#51afef',
            red = '#ec5f67',
            inactive = '#808080',
            gray = '#808080'
        }

        local conditions = {
            buffer_not_empty = function() return vim.fn.empty(vim.fn.expand('%:t', nil, nil)) ~= 1 end,
            nest_active_file_name_in_width = function() return vim.fn.winwidth(0) > 140 end,
            hide_encoding_in_width = function() return vim.fn.winwidth(vim.fn.winnr()) > 120 end,
            check_git_workspace_hide_in_width = function()
                local filepath = vim.fn.expand('%:p:h', nil, nil)
                local gitdir = vim.fn.finddir('.git', filepath .. ';')
                return gitdir and #gitdir > 0 and #gitdir < #filepath and vim.fn.winwidth(0) > 110
            end,
            hide_diagnostics_in_width = function() return vim.fn.winwidth(0) > 105 end,
            nest_project_prefix_in_width = function() return vim.fn.winwidth(0) > 100 end,
            hide_project_in_width = function() return vim.fn.winwidth(0) > 90 end,
            active_add_wind_in_width = function() return vim.fn.winwidth(0) <= 90 end,
            buffer_not_empty_hide_size_in_width = function() 
                return vim.fn.empty(vim.fn.expand('%:t', nil, nil)) ~= 1 and vim.fn.winwidth(vim.fn.winnr()) > 70
            end,
            hide_progress_in_width = function() return vim.fn.winwidth(0) > 60 end,
            hide_pomodoro_in_width = function() return vim.fn.winwidth(0) > 55 end,
            hide_clock_in_width = function() return vim.fn.winwidth(0) > 28 end,
            buffer_not_empty_hide_file_in_width = function() return vim.fn.empty(vim.fn.expand('%:t')) ~= 1 and vim.fn.winwidth(0) > 40 end,
            inactive_buffer_not_empty_hide_file_in_width = function() return vim.fn.empty(vim.fn.expand('%:t')) ~= 1 and vim.fn.winwidth(vim.fn.winnr()) > 25 end,
            inactive_buffer_not_empty_nest_file_in_width = function() return vim.fn.empty(vim.fn.expand('%:t')) ~= 1 and vim.fn.winwidth(vim.fn.winnr()) > 40 end,
        }

        -- Config
        local config = {
            options = {
                -- Disable sections and component separators
                component_separators = "",
                theme = custom_theme,
                section_separators = "",
                --style = {
                    ---- We are going to use lualine_c an lualine_x as left and
                    ---- right section. Both are highlighted by c theme .  So we
                    ---- are just setting default looks o statusline
                    --normal = {c = {fg = colors.fg, bg = colors.bg}},
                    --inactive = {c = {fg = colors.fg, bg = colors.bg}}
                --},
                disabled_filetypes = {'WhichKey', 'nofile', 'NvimTree', 'vista', 'packer'}
            },
            sections = {
                -- these are to remove the defaults
                lualine_a = {},
                lualine_b = {},
                lualine_y = {},
                lualine_z = {},
                -- These will be filled later
                lualine_c = {},
                lualine_x = {}
            },
            inactive_sections = {
                -- these are to remove the defaults
                lualine_a = {},
                lualine_v = {},
                lualine_y = {},
                lualine_z = {},
                lualine_c = {},
                lualine_x = {}
            }
        }

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

        ins_left_active {
            function() return '▊' end,
            color = {fg = colors.blue}, -- Sets highlighting of component
            padding = { left = 0 },
        }


        ins_left_active {
            -- mode component
            function()
                -- auto change color according to neovims mode
                local mode_color = {
                    n = colors.red,
                    i = colors.green,
                    v = colors.blue,
                    [''] = colors.blue,
                    V = colors.blue,
                    [''] = colors.blue,
                    c = colors.magenta,
                    no = colors.red,
                    s = colors.orange,
                    S = colors.orange,
                    [''] = colors.orange,
                    ic = colors.yellow,
                    R = colors.violet,
                    Rv = colors.violet,
                    cv = colors.red,
                    ce = colors.red,
                    r = colors.cyan,
                    rm = colors.cyan,
                    ['r?'] = colors.cyan,
                    ['!'] = colors.red,
                    t = colors.red
                }
                vim.api.nvim_command(
                'hi! LualineMode guifg=' .. mode_color[vim.fn.mode()] .. " guibg=" .. colors.bg)
                return '  '
            end,
            color = "LualineMode",
            padding = { left = 0 },
        }

        ins_left_active {
            -- filesize component
            function()
                local function format_file_size(file)
                    local size = vim.fn.getfsize(file)
                    if size <= 0 then return '' end
                    local sufixes = {'b', 'k', 'm', 'g'}
                    local i = 1
                    while size > 1024 do
                        size = size / 1024
                        i = i + 1
                    end
                    return string.format('%.1f%s', size, sufixes[i])
                end
                local file = vim.fn.expand('%:p')
                if string.len(file) == 0 then return '' end
                return format_file_size(file)
            end,
            cond = conditions.buffer_not_empty_hide_size_in_width
        }

        ins_left_active {
            function()
                local fname = vim.fn.getcwd()
                local path = Path:new(fname)
                local split_path = path:_split()
                if not conditions.nest_active_file_name_in_width() then
                    return vim.fn.expand('%')
                else
                    return table.concat({split_path[#split_path], vim.fn.expand('%')}, '/')
                end
            end,
            cond = conditions.buffer_not_empty_hide_file_in_width,
            color = {fg = colors.magenta, gui = 'bold'},
            file_status = true, -- displays file status (readonly status, modified status)
        }

        --ins_left_active {'location'}

        ins_left_active {'progress', color = {fg = colors.fg}, cond=conditions.hide_progress_in_width}

        if USE_COC then
            ins_left_active {
                'diagnostics',
                sources = {'coc'},
                symbols = {error = ' ', warn = ' ', info = ' '},
                diagnostics_color = {
                    error = { fg = colors.red },
                    warning = { fg = colors.yellow },
                    info = { fg = colors.cyan },
                    hint = { fg = colors.cyan },
                },
                cond = conditions.hide_diagnostics_in_width
            }
            ins_left_active {
                'g:coc_status',
            }
        else
            ins_left_active {
                'diagnostics',
                sources = {'nvim_lsp'},
                symbols = {error = ' ', warn = ' ', info = ' '},
                color_error = colors.red,
                color_warn = colors.yellow,
                color_info = colors.cyan,
                cond = conditions.hide_diagnostics_in_width
            }
        end
        -- Insert mid section. You can make any number of sections in neovim :)
        -- for lualine it's any number greater then 2
        ins_left_active {function() return '%=' end}

        ins_left_active {
            -- Lsp server name .
            function()
                local fname = vim.fn.getcwd()
                local path = Path:new(fname)
                local project_name = nil
                while (path.filename ~= home_path.filename) and (path.filename ~= root.filename) and (project_name == nil) do
                    for _,pattern in ipairs(root_patterns) do
                        if path:joinpath(pattern):exists() then
                            local split_path = path:_split()
                            project_name = split_path[#split_path]
                            break
                        end
                    end
                    path = path:parent()
                end

                local prefix = ''
                if conditions.nest_project_prefix_in_width() then
                    prefix =  "  Project: "
                else
                    prefix =  ""
                end
                if project_name ~= nil then
                    return prefix..project_name
                else
                    return prefix.."THIS IS NOT A NORMAL PROJECT"
                end
            end,
            icon = '',
            color = {fg = colors.fg},
            cond = conditions.hide_project_in_width
        }
        ins_left_active {
            function()
                local cur_winnr = vim.fn.winnr()
                local win_display_list = {"❶", "❷", "❸", "❹", "❺", "❻", "❼", "❽", "❾"}
                if cur_winnr > #win_display_list then
                    return " "
                end
                return win_display_list[cur_winnr]
            end,
            color = {fg = colors.blue, gui = 'bold'}, -- Sets highlighting of component
            padding = { left = 0 },
            cond = conditions.active_add_wind_in_width
        }
        --ins_left_active { INFO: buildin LSP status
            ---- Lsp server name .
            --function()
                --local msg = 'No Active Lsp'
                --local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
                --local clients = vim.lsp.get_active_clients()
                --if next(clients) == nil then return msg end
                --for _, client in ipairs(clients) do
                    --local filetypes = client.config.filetypes
                    --if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                        --return client.name
                    --end
                --end
                --return msg
            --end,
            --icon = ' LSP:',
            --color = {fg = '#dfffff', gui = 'bold'}
        --}

        -- Add components to right sections

        ins_right_active {
            function()
                local pomodoro = require('user.pomodoro')
                local display = ""
                display = display.."DONE "..tostring(pomodoro.finished_pomo).."*"
                return display
            end,
            icon = '',
            color = {fg = colors.magenta},
            cond = conditions.hide_pomodoro_in_width
        }

        ins_right_active {
            function()
                local pomodoro = require('user.pomodoro')
                local display = ""
                if pomodoro.reserve then
                    display = display.."  "..string.format("%d", (pomodoro.pomo_minites - pomodoro.reserve) / pomodoro.pomo_minites * 100).."%% "
                end
                return display
            end,
            icon = '',
            color = {fg = colors.violet}
        }


        -- Add components to right sections
        ins_right_active {
            'o:encoding', -- option component same as &encoding in viml
            fmt = string.upper, -- I'm not sure why it's upper case either ;)
            cond = conditions.hide_encoding_in_width,
            color = {fg = colors.green, gui = 'bold'}
        }

        --ins_right_active {
            --'fileformat',
            --fmt = string.upper,
            --icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
            --color = {fg = colors.green, gui = 'bold'}
        --}

        ins_right_active {
            'branch',
            icon = '',
            cond = conditions.check_git_workspace_hide_in_width,
            color = {fg = colors.violet, gui = 'bold'}
        }

        ins_right_active {
            'diff',
            -- Is it me or the symbol for modified us really weird
            symbols = {added = ' ', modified = ' ', removed = ' '},
            diff_color = {
                added = { fg = colors.green },
                modified = { fg = colors.orange },
                removed = { fg = colors.red },
            },
            cond = conditions.check_git_workspace_hide_in_width
        }
        ins_right_active {
            function()
                local date = 'None date'
                date = os.date("%H:%M")
                return ' '..date
            end,
            icon = '',
            color = {fg = colors.yellow, gui = 'bold'},
            cond = conditions.hide_clock_in_width
        }

        --▊ ▌▐,█
        ins_right_active {
            function() return '█' end,
            color = {fg = colors.blue},
            padding = { right = 0 },
        }
        -- Inserts a component in lualine_c at left section
        local function ins_left_inactive(component)
            insert_target(config.inactive_sections.lualine_c, component)
        end

        -- Inserts a component in lualine_x ot right section
        local function ins_right_inactive(component)
            insert_target(config.inactive_sections.lualine_x, component)
        end
        ins_left_inactive {
            function() return '▊' end,
            color = {fg = colors.gray}, -- Sets highlighting of component
            padding = { left = 0 },
        }
        ins_left_inactive {
            -- filesize component
            function()
                local function format_file_size(file)
                    local size = vim.fn.getfsize(file)
                    if size <= 0 then return '' end
                    local sufixes = {'b', 'k', 'm', 'g'}
                    local i = 1
                    while size > 1024 do
                        size = size / 1024
                        i = i + 1
                    end
                    return string.format('%.1f%s', size, sufixes[i])
                end
                local file = vim.fn.expand('%:p', nil, nil)
                if string.len(file) == 0 then return '' end
                return format_file_size(file)
            end,
            cond = conditions.buffer_not_empty_hide_size_in_width,
            color = {fg = colors.inactive}, -- Sets highlighting of component
        }


        ins_left_inactive {
            function()
                local fname = vim.fn.getcwd()
                local path = Path:new(fname)
                local split_path = path:_split()
                if conditions.inactive_buffer_not_empty_nest_file_in_width then
                    return vim.fn.expand('%')
                else
                    return table.concat({split_path[#split_path], vim.fn.expand('%')}, '/')
                end
            end,
            cond = conditions.inactive_buffer_not_empty_hide_file_in_width,
            color = {fg = colors.inactive, gui = 'bold'},
            file_status = true, -- displays file status (readonly status, modified status)
        }
        ins_left_inactive {function() return '%=' end}

        ins_left_inactive {
            function()
                local cur_winnr = vim.fn.winnr()
                local win_display_list = {"❶", "❷", "❸", "❹", "❺", "❻", "❼", "❽", "❾"}
                if cur_winnr > #win_display_list then
                    return " "
                end
                return win_display_list[cur_winnr]
            end,
            color = {fg = colors.blue, gui = 'bold'}, -- Sets highlighting of component
            padding = { left = 0 },
        }
        -- Add components to right sections
        ins_right_inactive {
            'o:encoding', -- option component same as &encoding in viml
            fmt = string.upper, -- I'm not sure why it's upper case either ;)
            cond = conditions.hide_encoding_in_width,
            color = {fg = colors.inactive, gui = 'bold'}
        }

        --ins_right_inactive {
            --'fileformat',
            --fmt = string.upper,
            --icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
            --color = {fg = colors.inactive, gui = 'bold'}
        --}

        ins_right_inactive {
            'branch',
            icon = '',
            cond = conditions.check_git_workspace_hide_in_width,
            color = {fg = colors.inactive, gui = 'bold'}
        }

        ins_right_inactive {
            'diff',
            -- Is it me or the symbol for modified us really weird
            symbols = {added = ' ', modified = ' ', removed = ' '},
            diff_color = {
                added = { fg = colors.inactive },
                modified = { fg = colors.inactive },
                removed = { fg = colors.inactive },
            },
            cond = conditions.check_git_workspace_hide_in_width
        }

        ins_right_inactive {
            function() return '█' end,
            color = {fg = colors.gray},
            padding = { right = -1 },
        }

        -- Now don't forget to initialize lualine
        lualine.setup(config)

        local timer = vim.loop.new_timer()
        timer:start(1000, 15000, vim.schedule_wrap(function()
            vim.cmd('redrawstatus')
        end))

        --local fix_statusline_hl_timer = vim.loop.new_timer()
        --fix_statusline_hl_timer:start(1500, 0, vim.schedule_wrap(function()
            --vim.cmd("hi StatusLine guibg="..colors.blue)
        --end))
    end,
}

plugin.mapping = function()

    local mappings = require('core.mapping')
    for i=1,9,1 do
        mappings.register({
            mode = "n",
            key = {"<localleader>", tostring(i)},
            action = tostring(i)..'<c-w><c-w>',
            short_desc = "Goto "..tostring(i).." Window",
            noremap = true,
            silent = true,
        })
    end
end

return plugin
