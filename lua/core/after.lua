-- special setting

local mappings = require('core.mapping')
local plugins_config = require('core.plugins')

if plugins_config.all_loaded_module['indent_line'] ~= nil then
    mappings.register({
        mode = "n",
        key = {"<leader>", "<TAB>"},
        action = "za:IndentBlanklineRefresh<CR>",
        short_desc = "Smart toggle fold",
        silent = true
    })
else
    mappings.register({
        mode = "n",
        key = {"<leader>", "<TAB>"},
        action = "@=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>",
        short_desc = "Smart toggle fold",
        silent = true
    })
end

vim.cmd([[
    inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<tab>"
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
]])


vim.cmd("hi! link SignColumn LineNr")   --set VertSplit color to black
vim.cmd("autocmd ColorScheme, VimEnter * highlight! link SignColumn LineNr")
vim.cmd("hi VertSplit ctermfg=black guifg=black")   --set VertSplit color to black
vim.cmd("hi StatusLine ctermfg=black guifg=black")  --set HSplit color to black
--hi VertSplit ctermbg=NONE guibg=string(synIDattr(hlID("Normal"), "bg"))   -- TODO if the above setting not work as espect, maybe these setting will work
--hi VertSplit ctermbg=NONE guibg=dark
--hi StatusLine ctermbg=NONE guibg=string(synIDattr(hlID("Normal"), "bg"))
--hi StatusLine ctermbg=NONE guibg=dark

vim.cmd("highlight LspDiagnosticsDefaultError guifg='BrightRed'")
vim.fn.sign_define("LspDiagnosticsSignError", {text = "", texthl = "LspDiagnosticsSignError"})
vim.fn.sign_define("LspDiagnosticsSignWarning", {text = "", texthl = "LspDiagnosticsSignWarning"})
vim.fn.sign_define("LspDiagnosticsSignInformation", {text = "", texthl = "LspDiagnosticsSignInformation"})
vim.fn.sign_define("LspDiagnosticsSignHint", {text = "ᐅ", texthl = "LspDiagnosticsSignHint"})

if plugins_config.plugins_groups['default']['which_key'] and plugins_config.plugins_groups['default']['which_key']['disable'] == false then
    vim.cmd("packadd which-key.nvim")
    local wk = require("which-key")
    wk.register(mapping_prefix)
end
