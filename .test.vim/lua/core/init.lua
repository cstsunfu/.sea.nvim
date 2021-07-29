vim.g.python3_host_prog = '/home/sun/anaconda3/bin/python3'


-- invoke default setting
require('core.default')

-- plugin configure, using packer.nvim to install plugins
feature_groups = {}
feature_groups.default = true
feature_groups.complete = true
feature_groups.colorschemes = true
feature_groups.beauty_vim = true
feature_groups.file = true
feature_groups.move_behavior = true

feature_groups.fzf = true
feature_groups.default_plugin = true
feature_groups.airline = true
feature_groups.goyo = true
feature_groups.jupyter_vim = true
feature_groups.linediff = true
feature_groups.ale = true
feature_groups.vista = true
feature_groups.lang_python = true
feature_groups.lang_java = true
feature_groups.lang_cpp = true
feature_groups.lang_latex = true
feature_groups.easy_change = true
feature_groups.wakatime = false
feature_groups.format = true
feature_groups.asyncrun = true
feature_groups.mirror = true
feature_groups.indentline = true
feature_groups.smooth_scroll = true
feature_groups.org_my_life = true
feature_groups.enhance_markdown = true
feature_groups.vimspector = true
feature_groups.translate_me = true
feature_groups.nerd_tree = true

require('core.plugins').setup()
require('core.mapping')
require('core.plugins').create_mapping()


local colorscheme = "gruvbox_material"
local theme = "dark"
require("configure."..colorscheme).setup(theme)


require('core.after')
