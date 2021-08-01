vim.g.python3_host_prog = '/home/sun/anaconda3/bin/python3'

-- invoke default setting
require('core.default')

-- plugin configure, using packer.nvim to install plugins
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
FEATURE_GROUPS.debug_adapter = true

FEATURE_GROUPS.fzf = true
FEATURE_GROUPS.default_plugin = true
FEATURE_GROUPS.airline = true
FEATURE_GROUPS.goyo = true
FEATURE_GROUPS.jupyter_vim = true
FEATURE_GROUPS.linediff = true
FEATURE_GROUPS.ale = true
FEATURE_GROUPS.vista = true
FEATURE_GROUPS.lang_python = true
FEATURE_GROUPS.lang_java = true
FEATURE_GROUPS.lang_cpp = true
FEATURE_GROUPS.lang_latex = true
FEATURE_GROUPS.easy_change = true
FEATURE_GROUPS.wakatime = false
FEATURE_GROUPS.format = true
FEATURE_GROUPS.asyncrun = true
FEATURE_GROUPS.mirror = true
FEATURE_GROUPS.indentline = true
FEATURE_GROUPS.smooth_scroll = true
FEATURE_GROUPS.org_my_life = true
FEATURE_GROUPS.enhance_markdown = true
FEATURE_GROUPS.vimspector = true
FEATURE_GROUPS.translate_me = true
FEATURE_GROUPS.nerd_tree = true

require('core.plugins').setup()
require('core.mapping')
require('core.plugins').create_mapping()


local colorscheme = "gruvbox_material"
local theme = "dark"
require("configure."..colorscheme).setup(theme)


require('core.after')
