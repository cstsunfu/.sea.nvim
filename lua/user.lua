local theme_configs = require('core.themes')
local theme_config = theme_configs.material_oceanic
vim.g.colorscheme_name = theme_config.name
vim.g.colorscheme = theme_config.colorscheme
vim.g.style = theme_config.style

vim.g.python3_host_prog = vim.g.HOME_PATH .. '/anaconda3/bin/python3' -- add to your own python3 path
vim.g.snips_author = 'Sun Fu'
vim.g.snips_email = 'cstsunfu@gmail.com'
vim.g.snips_github = 'https://github.com/cstsunfu'
vim.g.snips_wechat = 'cstsunfu'
