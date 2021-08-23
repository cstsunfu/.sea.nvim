local plugin = {}

plugin.core = {
    "shadmansaleh/lualine.nvim", -- TODO: if this branch is merged, I should change to the master 'hoob3rt/lualine.nvim',
    requires = {
        {'kyazdani42/nvim-web-devicons', opt = true},
        {'nvim-lua/plenary.nvim', opt=true},
    },
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

        -- Color table for highlights
        local colors = {
            fg = '#bbc2cf',
            yellow = '#ECBE7B',
            cyan = '#008080',
            darkblue = '#081633',
            green = '#98be65',
            orange = '#FF8800',
            violet = '#a9a1e1',
            magenta = '#c678dd',
            blue = '#51afef',
            red = '#ec5f67',
            gray = '#808080'
        }

        if vim.g.colorscheme == "gruvbox_material" then
            colors.bg = '#7c6f6c'
        else
            colors.bg = '#202328'
        end

        local conditions = {
            buffer_not_empty = function() return vim.fn.empty(vim.fn.expand('%:t')) ~= 1 end,
            hide_in_width = function() return vim.fn.winwidth(0) > 80 end,
            check_git_workspace = function()
                local filepath = vim.fn.expand('%:p:h')
                local gitdir = vim.fn.finddir('.git', filepath .. ';')
                return gitdir and #gitdir > 0 and #gitdir < #filepath
            end
        }

        -- Config
        local config = {
            options = {
                -- Disable sections and component separators
                component_separators = "",
                section_separators = "",
                theme = {
                    -- We are going to use lualine_c an lualine_x as left and
                    -- right section. Both are highlighted by c theme .  So we
                    -- are just setting default looks o statusline
                    normal = {c = {fg = colors.fg, bg = colors.bg}},
                    inactive = {c = {fg = colors.fg, bg = colors.bg}}
                },
                disabled_filetypes = {'WhichKey', 'nofile', 'NvimTree', 'vista'}
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
            left_padding = 0 -- We don't need space before this
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
                return ''
            end,
            color = "LualineMode",
            left_padding = 0
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
            condition = conditions.buffer_not_empty
        }

        ins_left_active {
            'filename',
            condition = conditions.buffer_not_empty,
            color = {fg = colors.magenta, gui = 'bold'},
            file_status = true, -- displays file status (readonly status, modified status)
            path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
        }

        ins_left_active {'location'}

        ins_left_active {'progress', color = {fg = colors.fg, gui = 'bold'}}

        if USE_COC then
            ins_left_active {
                'diagnostics',
                sources = {'coc'},
                symbols = {error = ' ', warn = ' ', info = ' '},
                color_error = { fg = colors.red },
                color_warn = { fg = colors.yellow },
                color_info = { fg = colors.cyan }
            }
            ins_left_active {
                'g:coc_status',
            }
        else
            ins_left_active {
                'diagnostics',
                sources = {'nvim_lsp'},
                symbols = {error = ' ', warn = ' ', info = ' '},
                color_error = colors.red,
                color_warn = colors.yellow,
                color_info = colors.cyan
            }
        end
        -- Insert mid section. You can make any number of sections in neovim :)
        -- for lualine it's any number greater then 2
        ins_left_active {function() return '%=' end}

        if USE_COC == true then
            ins_left_active {
                -- Lsp server name .
                function()
                    local fname = vim.fn.getcwd()
                    local path = Path:new(fname)
                    while (path.filename ~= home_path.filename) and (path.filename ~= root.filename) do
                        for _,pattern in ipairs(root_patterns) do
                            if path:joinpath(pattern):exists() then
                                local split_path = path:_split()
                                return split_path[#split_path]
                            end
                        end
                        path = path:parent()
                    end
                    return "*WARNING* THIS IS NOT A NORMAL PROJECT"
                end,
                icon = ' Project:',
                color = {fg = '#ffffff', gui = 'bold'}
            }
        else
            ins_left_active {
                -- Lsp server name .
                function()
                    local msg = 'No Active Lsp'
                    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
                    local clients = vim.lsp.get_active_clients()
                    if next(clients) == nil then return msg end
                    for _, client in ipairs(clients) do
                        local filetypes = client.config.filetypes
                        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                            return client.name
                        end
                    end
                    return msg
                end,
                icon = ' LSP:',
                color = {fg = '#ffffff', gui = 'bold'}
            }
        end

        -- Add components to right sections

        ins_right_active {
            function()
                local pomodoro = require('user.pomodoro')
                local display = ""
                display = display.."DONE "..tostring(pomodoro.finished_pomo).."*"
                return display
            end,
            icon = '',
            color = {fg = colors.magenta}
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
            upper = true, -- I'm not sure why it's upper case either ;)
            condition = conditions.hide_in_width,
            color = {fg = colors.green, gui = 'bold'}
        }

        ins_right_active {
            'fileformat',
            upper = true,
            icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
            color = {fg = colors.green, gui = 'bold'}
        }

        ins_right_active {
            'branch',
            icon = '',
            condition = conditions.check_git_workspace,
            color = {fg = colors.violet, gui = 'bold'}
        }

        ins_right_active {
            'diff',
            -- Is it me or the symbol for modified us really weird
            symbols = {added = ' ', modified = ' ', removed = ' '},
            color_added = { fg = colors.green },
            color_modified = { fg = colors.orange },
            color_removed = { fg = colors.red },
            condition = conditions.hide_in_width
        }
        ins_right_active {
            function()
                local date = 'None date'
                date = os.date("%H:%M")
                return date
            end,
            icon = ' ',
            color = {fg = colors.yellow, gui = 'bold'}
        }


        ins_right_active {
            function() return '▊' end,
            color = {fg = colors.blue},
            right_padding = 0
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
            left_padding = 0 -- We don't need space before this
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
                local file = vim.fn.expand('%:p')
                if string.len(file) == 0 then return '' end
                return format_file_size(file)
            end,
            condition = conditions.buffer_not_empty,
            color = {fg = colors.gray}, -- Sets highlighting of component
        }


        ins_left_inactive {
            'filename',
            condition = conditions.buffer_not_empty,
            --color = {fg = colors.gray, gui = 'bold'},
            file_status = true, -- displays file status (readonly status, modified status)
            path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
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
            left_padding = 0 -- We don't need space before this
        }
        -- Add components to right sections
        ins_right_inactive {
            'o:encoding', -- option component same as &encoding in viml
            upper = true, -- I'm not sure why it's upper case either ;)
            condition = conditions.hide_in_width,
            color = {fg = colors.gray, gui = 'bold'}
        }

        ins_right_inactive {
            'fileformat',
            upper = true,
            icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
            --color = {fg = colors.gray, gui = 'bold'}
        }

        ins_right_inactive {
            'branch',
            icon = '',
            condition = conditions.check_git_workspace,
            --color = {fg = colors.gray, gui = 'bold'}
        }

        ins_right_inactive {
            'diff',
            -- Is it me or the symbol for modified us really weird
            symbols = {added = ' ', modified = ' ', removed = ' '},
            color_added = { fg = colors.green },
            color_modified = { fg = colors.orange },
            color_removed = { fg = colors.red },
            condition = conditions.hide_in_width
        }

        ins_right_inactive {
            function() return '▊' end,
            color = {fg = colors.gray},
            right_padding = 0
        }

        -- Now don't forget to initialize lualine
        lualine.setup(config)

        local timer = vim.loop.new_timer()
        timer:start(1000, 15000, vim.schedule_wrap(function()
            vim.cmd('redrawstatus')
        end))
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
