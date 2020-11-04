" File: init.vim
" Author: Sun Fu
" Description: init file for vim
" Last Modified: November 03, 2020

set runtimepath^=$HOME/.sunfu.vim runtimepath+=$HOME/.sunfu.vim/after runtimepath+=$HOME/.sunfu.vim/modules
let g:root_path=$HOME.'/.sunfu.vim/'
let &packpath = &runtimepath


let g:load_fzf = 1
let g:load_default_plugin = 1
let g:load_colorschemes = 1
let g:load_airline = 1
let g:load_beauty_vim = 1
let g:load_goyo = 1
let g:load_jupyter_vim = 1
let g:load_linediff = 1
let g:load_ycm = 1
let g:load_ale = 1
let g:load_vista = 1
let g:load_lang_python = 1
let g:load_lang_java = 1
let g:load_lang_cpp = 1
let g:load_lang_latex = 1
let g:load_easy_change = 1
let g:load_wakatime = 1
let g:load_format = 1
let g:load_asyncrun = 1
let g:load_mirror = 1
let g:load_indentline = 1
let g:load_smooth_scroll = 1
let g:load_org_my_life = 1
let g:load_enhance_markdown = 1
let g:load_vimspector = 1
let g:load_translate_me = 1
let g:load_nerd_tree = 1
if has('nvim')
    let g:load_defx = 1
endif


call plug#begin(g:root_path.'plugged')
exec 'source'.g:root_path.'plugins.vim'
call plug#end()


set background=dark
"set background=light
let themes = ['gruvbox', 'NeoSolarized', 'nord', 'one', 'space-vim-dark', 'OceanicNext', 'palenight']
execute 'colorscheme '.themes[str2nr(strftime('%d')) % len(themes)]

exec 'source '.g:root_path.'configure/default.vim'
exec 'source '.g:root_path.'configure/setting.vim'

if exists('g:load_defx') && g:load_defx
    exec 'source '.g:root_path.'configure/dfx.vim'
endif
if exists('g:load_airline') && g:load_airline
    exec 'source '.g:root_path.'configure/airline.vim'
endif
exec 'source '.g:root_path.'configure/after.vim'
exec 'source '.g:root_path.'configure/shortcut.vim'

"nnoremap zpr :setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=2<CR>:set foldmethod=manual<CR><CR>
"================================================================================================================
