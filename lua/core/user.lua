local M = {}
local local_setup = function()
    require("core.local").setup()
end

M.setup = function()
    pcall(local_setup)

    local themes = require("core.themes")

    if os.getenv("GLOBAL_THEME") == "light" then
        themes.setting(themes.configs.material_light)
    else
        themes.setting(themes.configs.material_palenight)
    end

    local user_setting = {
        python3_host_prog = vim.g.HOME_PATH .. "/miniconda3/bin/python3", -- add to your own python3 path
        snips_author = "Sun Fu",
        snips_email = "cstsunfu@gmail.com",
        snips_github = "https://github.com/cstsunfu",
        snips_wechat = "cstsunfu",
    }

    for key, value in pairs(user_setting) do
        vim.g[key] = value
    end

    if vim.g.my_dlk_tools then -- this is just used for my own deep learning python packages dlk, so this will not effect you
        require("util.dlk_util")
    end
end

M.after = function()
    local local_after = function()
        require("core.local").after()
    end
    pcall(local_after)
end

return M
