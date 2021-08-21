-- invoke default setting
require('core.default')

-- plugin configure, using packer.nvim to install plugins
--vim.g.colorscheme = "gruvbox_material"
--vim.g.colorscheme = "rose_pine"
vim.g.colorscheme = "nord"
vim.g.theme = "dark"

USE_COC = true
FEATURE_GROUPS = {}
FEATURE_GROUPS.default = true
if USE_COC then
    FEATURE_GROUPS.coc_complete = true
else
    FEATURE_GROUPS.buildin_complete = true
end
FEATURE_GROUPS.colorschemes = true
FEATURE_GROUPS.beauty_vim = true
FEATURE_GROUPS.file_and_view = true
FEATURE_GROUPS.move_behavior = true
FEATURE_GROUPS.special_for_language = true
FEATURE_GROUPS.debug_adapter = true
FEATURE_GROUPS.org_my_life = true
FEATURE_GROUPS.enhance = true
FEATURE_GROUPS.git = true


require('core.plugins').setup()
require('user').setup({pomodoro={dir_path=vim.g.HOME_PATH..'/wiki/pomodoro/'}})

require('core.mapping')
require('core.plugins').create_mapping()
require("configure."..vim.g.colorscheme).setup(vim.g.theme)

require('core.after')
--vim.cmd("source ~/.cache/calendar.vim/credentials.vim")
