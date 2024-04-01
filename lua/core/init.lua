vim.g.feature_groups = {
    default = true,
    lsp = "builtin", --"builtin" or "coc" or set to nil/false to disable lsp
    --lsp = "coc", --"builtin" or "coc" or set to nil/false to disable lsp
    colorschemes = true,
    beauty_vim = true,
    file_and_view = true,
    special_for_language = true,
    debug_adapter = true,
    org_my_life = true,
    enhance = true,
    git = true,
}

require("core.default")

local local_setup = function()
    require("core.local").setup()
end
require("core.user")
require("core.plugins").setup()
pcall(local_setup)
require("hack").setup({ pomodoro = { dir_path = vim.g.HOME_PATH .. "/org/pomodoro/" } })

require("core.plugins").create_mapping()
require("hack").create_mapping()
require("core.mapping").setup()
require("configure." .. vim.g.colorscheme).setup(vim.g.style)
if vim.g.neovide then
    require("core.gui").setup()
end

require("core.after")
local local_after = function()
    require("core.local").after()
end
pcall(local_after)
