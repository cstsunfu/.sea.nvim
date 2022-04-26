local theme_configs = require('core.themes')
local theme_config = theme_configs.vscode_dark
--local theme_config = theme_configs.nord

vim.g.colorscheme = theme_config[1]
vim.g.theme = theme_config[2]

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


require('core.default')
require('core.plugins').setup()
require('user').setup({pomodoro={dir_path=vim.g.HOME_PATH..'/org/pomodoro/'}})

require('core.plugins').create_mapping()
require('user').create_mapping()
require('core.mapping').setup()
require("configure."..vim.g.colorscheme).setup(vim.g.theme)

require('core.after')
