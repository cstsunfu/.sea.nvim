local M = {}
local util = require('util.global')
local json = require("util.json")
local timer = nil
M.dir_path = vim.g.HOME_PATH..'.local/pomodoro'
M.cur_proj = nil
M.max_select_mru = 9
M.pomo_minites = 25
M.today = os.date("%Y_%m_%d")
M.reserve = nil
M.finished_pomo = 0

_G.pomodoro = {}

_G.pomodoro.proj_complete = function(arg_lead)
    return table.concat(M.mru, "\n")
end

local get_proj = function()
    if not packer_plugins['plenary.nvim'].loaded then
        vim.cmd [[packadd plenary.nvim]]
    end
    local Path = require'plenary.path'
    local root = Path:new("/")
    local root_patterns = {".git", "setup.py", "setup.cfg", "pyproject.toml", "requirements.txt"}
    local home_path = Path:new(vim.g.HOME_PATH)
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
    return "Others"
end

local menu = function(tab)

    local option = {{ label = '', separator = '-', length = 34 }}
    for idx,proj in ipairs(tab) do
        if idx > M.max_select_mru then
            break
        end
        table.insert(option, idx, {
            label = proj,
            key = tostring(idx),
            action = function()
                M.cur_proj = vim.fn.input('Confirm Project Name, "x" means "Others": ', proj, 'custom,v:lua.pomodoro.proj_complete')
            end
        })
    end
    local project_dir = get_proj()

    table.insert(option, #option+1, { label = 'Current project directory name', key = 'c',
        action = function()
            local proj = vim.fn.input('Confirm Project Name, "x" means "Others": ', project_dir, 'custom,v:lua.pomodoro.proj_complete')
            M.cur_proj = proj
        end
    })

    table.insert(option, #option+1, { label = 'Input project name', key = 'i',
        action = function()
            local proj = vim.fn.input('Enter Project Name, "x" means "Others": ', '', 'custom,v:lua.pomodoro.proj_complete')
            if proj == "x" then
                proj = "Others"
            end
            M.cur_proj = proj
        end
    })

    table.insert(option, #option+1, { label = 'Quit', key = 'q' })
    table.insert(option, #option+1, { label = '', separator = ' ', length = 1 })

    util.menu("Press Key For Select Project Name",
        option,
        'Press key'
    )
end

local reset = function()
    M.date = os.date("%Y_%m_%d")
    M.finished_pomo = 0
    M.file_path = M.dir_path.."/"..M.date..".json"
    M.data = json.decode(util.sync_read_file(M.file_path) or "{}")
    for _,val in pairs(M.data) do
        M.finished_pomo = M.finished_pomo + val
    end
end

M.start_pomodoro = function()
    local date = os.date("%Y_%m_%d")
    if date ~= M.today then
        M.today = date
        reset()
    end

    menu(M.mru)
    if M.cur_proj == "" or not M.cur_proj then
        M.cur_proj = nil
        vim.notify("Please Input a Valid Projct Name.", vim.lsp.log_levels.ERROR, {
			title = "ERROR",
            icon = "",
            timeout = 3000,
		})
        return
    end
    local idx = util.index(M.mru, M.cur_proj)
    if (not idx) and (#M.mru >= M.max_mru) then
        table.remove(M.mru, #M.mru)
    elseif idx then
        table.remove(M.mru, idx)
    end
    table.insert(M.mru, 1, M.cur_proj)
    timer = vim.loop.new_timer()
    M.reserve = M.pomo_minites
    timer:start(100, 15000, vim.schedule_wrap(function()
        M.reserve = M.reserve - 0.25
        if M.reserve <= 0 then
            M.stop_pomodoro()
        end
    end))
    vim.notify("You Start a Pomodoro Clock on Project '"..M.cur_proj.."'!", vim.lsp.log_levels.INFO, {
        title = "Start a pomodoro clock.",
        icon = "",
        timeout = 3000,
    })
end

M.stop_pomodoro = function()
    if M.reserve == nil then
        vim.notify("There is Not a Pomodoro Run.", vim.lsp.log_levels.ERROR, {
			title = "ERROR",
            icon = "",
            timeout = 3000,
		})
        return
    end
    timer:stop()
    if M.reserve > 0 then
        vim.notify("Unfinished Pomodoro Clock on Project '"..M.cur_proj.."'!", vim.lsp.log_levels.WARN, {
			title = "WARNING",
            icon = "",
            timeout = 3000,
		})
        M.reserve = nil
        return
    end
    M.reserve = nil
    M.finished_pomo  = M.finished_pomo + 1
    local cur_proj_pomo = M.data[M.cur_proj]
    if not cur_proj_pomo then
        cur_proj_pomo = 0
    end
    M.data[M.cur_proj] = cur_proj_pomo + 1
    util.async_write_file(M.mru_path, table.concat(M.mru, '\n'))
    util.async_write_file(M.dir_path.."/"..M.date..".json", json.encode(M.data))

    vim.notify("You Finished One Pomodoro Clock on Project '"..M.cur_proj.."'!", vim.lsp.log_levels.INFO, {
        title = "You Finished One Pomodoro Clock!",
        icon = "",
        timeout = 3000,
    })
end


M.setup = function (config)

    for name,val in pairs(config) do
        M[name] = val
    end
    M.max_mru = 1000
    M.mru_path = M.dir_path.."/".."mru.txt"
    M.mru = util.split(util.sync_read_file(M.mru_path) or "", '\n')
    reset()
end


return M
