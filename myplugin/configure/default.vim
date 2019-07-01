" File              : default.vim
" Author            : Sun Fu <cstsunfu@gmail.com>
" Date              : 28.03.2018
" Last Modified Date: 01.07.2019
" Last Modified By  : Sun Fu <cstsunfu@gmail.com>
" File              : default.vim
" Author            : Sun Fu <cstsunfu@gmail.com>
" Date              : 28.03.2018
" Last Modified Date: 28.03.2018
" Last Modified By  : Sun Fu <cstsunfu@gmail.com>
" Select blocks after indenting
xnoremap < <gv
xnoremap > >gv|
nnoremap za zA
"terminal esc
tnoremap <esc> <C-\><C-n>




"lazyredraw
set lazyredraw
set ttyfast
hi CursorLine term=bold cterm=bold guibg=Grey40
"颜色渲染长度
set synmaxcol=200

filetype plugin on    "自适应不同文件插件不同
set mouse=a
filetype on "开启文件类型侦测
set autochdir    " 自动递归查找
set shellslash   "change
set grepprg=grep\ -nH\ $*
set nocompatible "禁用vi兼容
set shortmess+=c
set relativenumber
set number " 行号显示
let maplocalleader=','
let mapleader=';' 
nnoremap \ ;
let g:vimwiki_map_prefix='<leader>o'
let g:tex_flavor = "latex"
set ignorecase
set smartcase
syntax enable    "开启语法高亮
syntax on        "允许制定语法高亮替换默认的        
set autoindent "自动缩进
"set guifont=YaHei\ Consolas\ Hybrid\ 11.5   "字体， 最后为字大小
"set guifont=DroidSansMono\ Nerd\ Font\ 11
"set guifont=DroidSansMonoForPowerline\ Nerd\ Font\ Book\ 9.5
"highlight VertSplit ctermbg=10 ctermfg=10
"set fillchars+=stl:\ ,stlnc:-,vert:| ,fold:-,diff:- 
"hi VertSplit            ctermfg=LightBlue            ctermbg=Grey

" set fillchar
set fillchars+=vert:\        "修改分割线为空格 
"set fillchars+=vert:\|
hi VertSplit ctermbg=NONE guibg=NONE
hi VertSplit ctermfg=black guifg=black
hi StatusLine ctermbg=NONE guibg=NONE
hi StatusLine ctermfg=black guifg=black
set fillchars+=vert:│
"set fillchars+=vert:\│
"set fillchars+=stl:-
"

set hlsearch "高亮搜索结果
set autochdir "显示正确目录
set suffixesadd+=.cpp "搜索文件时自动添加.cpp后缀 即搜索./a ./a.cpp文件可以被搜索出来
"set backup  "生成备份"
"set backupext=.bak
inoremap jk <esc>
tnoremap jk <C-\><C-n>

set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
set mouse=a
" 设置编辑时制表符占用空格数
set path+=./** " path增加子目录
set ttimeoutlen=1 "配合fcitx使用
set incsearch
set noerrorbells    "not bell
set showcmd     "右下角显示未完成命令
filetype indent on

" 设置编辑时制表符占用空格数
set tabstop=4
" 将制表符扩展为空格
set expandtab
" 设置格式化时制表符占用空格数
set shiftwidth=4
" 让 vim 把连续数量的空格视为一个制表符
set softtabstop=4

set t_ut=        "避免背景和terminal配色不一样造成显示混乱，disable Backgroud color Erase（BCE）
set termguicolors
" Color name (:help cterm-colors) or ANSI code
"let g:limelight_conceal_ctermfg = 'gray'
"let g:limelight_conceal_ctermfg = 240
"基于缩进或语法进行代码折叠
set foldmethod=indent
"set foldmethod=syntax
"set foldignore="|"


" Tell Vimwiki to let me decide manually
"let g:vimwiki_folding = 'syntax'
"let g:vimwiki_folding += 'list'
function! MarkdownLevel()
    if getline(v:lnum) =~ '^# .*$'
	return ">1"
    endif
    if getline(v:lnum) =~ '^## .*$'
	return ">2"
    endif
    if getline(v:lnum) =~ '^### .*$'
	return ">3"
    endif
    if getline(v:lnum) =~ '^#### .*$'
	return ">4"
    endif
    if getline(v:lnum) =~ '^##### .*$'
	return ">5"
    endif
    if getline(v:lnum) =~ '^###### .*$'
	return ">6"
    endif
    return "=" 
endfunction
au BufEnter *.md setlocal foldexpr=MarkdownLevel()  
au BufEnter *.md setlocal foldmethod=expr    
augroup filetype_fold
    autocmd FileType startify setlocal nofoldenable
    autocmd BufRead,BufNewFile info.* setlocal nofoldenable
augroup END
set foldenable
"za 打开或关闭折叠 zM，关闭所有折叠，zR，打开所有折叠
nnoremap <leader><tab> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
" 用tab键来开关折叠
set guioptions-=m    "隐藏菜单栏    
set guioptions-=r   "隐藏右侧滚动条
set guioptions-=T    "隐藏工具栏
set guioptions-=L   "隐藏左侧滚动条

"let g:spchkmouse   = 1
"let g:spchkautonext= 1
"let g:spchkdialect = "usa"
set dictionary=~/.vim/dict/engspchk.dict
set complete-=k  
set complete+=k  "set complete option


" defx & vista
augroup vimrc_defx
    autocmd!
    "autocmd FileType defx call s:defx_mappings()                                  "Defx mappings
    autocmd FileType defx call s:defx_my_settings()
    autocmd VimEnter * call s:setup_defx()
    "autocmd VimEnter * call fugitive#detect(expand('<afile>')) | call lightline#update()
augroup END

nnoremap <silent><Leader>df :call <sid>defx_open({ 'split': v:true })<CR>
nnoremap <silent><Leader>hf :call <sid>defx_open({ 'split': v:true, 'find_current_file': v:true })<CR>
let s:default_columns = 'indent:git:icons:filename'

function! s:setup_defx() abort
    call defx#custom#option('_', {
                \ 'columns': s:default_columns,
                \ })

    call defx#custom#column('filename', {
                \ 'min_width': 80,
                \ 'max_width': 80,
                \ })

    call s:defx_open({ 'dir': expand('<afile>') })
endfunction

function s:get_project_root() abort
    let l:git_root = ''
    let l:path = expand('%:p:h')
    let l:cmd = systemlist('cd '.l:path.' && git rev-parse --show-toplevel')
    if !v:shell_error && !empty(l:cmd)
        let l:git_root = fnamemodify(l:cmd[0], ':p:h')
    endif

    if !empty(l:git_root)
        return l:git_root
    endif

    return getcwd()
endfunction

function! s:defx_open(...) abort
    let l:opts = get(a:, 1, {})
    let l:path = get(l:opts, 'dir', s:get_project_root())

    if !isdirectory(l:path) || &filetype ==? 'defx'
        return
    endif

    let l:args = '-winwidth=20 -direction=botright'
    "let l:args = '-winwidth=25 -direction=topleft'

    if has_key(l:opts, 'split')
        let l:args .= ' -split=vertical'
    endif

    if has_key(l:opts, 'find_current_file')
        if &filetype ==? 'defx'
            return
        endif
        call execute(printf('Defx %s -search=%s %s', l:args, expand('%:p'), l:path))
    else
        call execute(printf('Defx -toggle %s %s', l:args, l:path))
        call execute('wincmd p')
    endif

    return execute("norm!\<C-w>=")
endfunction

function! s:defx_context_menu() abort
    let l:actions = ['new_multiple_files', 'rename', 'copy', 'move', 'paste', 'remove']
    let l:selection = confirm('Action?', "&New file/directory\n&Rename\n&Copy\n&Move\n&Paste\n&Delete")
    silent exe 'redraw'

    return feedkeys(defx#do_action(l:actions[l:selection - 1]))
endfunction

function s:defx_toggle_tree() abort
    if defx#is_directory()
        return defx#do_action('open_or_close_tree')
    endif
    return defx#do_action('drop')
endfunction

function! s:defx_my_settings() abort
    " Define mappings
    nnoremap <silent><buffer><expr> <CR>
                \ defx#do_action('open')
    nnoremap <silent><buffer><expr> c
                \ defx#do_action('copy')
    nnoremap <silent><buffer><expr> m
                \ defx#do_action('move')
    nnoremap <silent><buffer><expr> p
                \ defx#do_action('paste')
    nnoremap <silent><buffer><expr> l
                \ defx#is_directory() ? defx#do_action('open') :
                \ defx#do_action('multi', ['drop'])
    nnoremap <silent><buffer><expr> E
                \ defx#do_action('open', 'vsplit')
    nnoremap <silent><buffer><expr> P
                \ defx#do_action('open', 'pedit')
    nnoremap <silent><buffer><expr> K
                \ defx#do_action('new_directory')
    nnoremap <silent><buffer><expr> N
                \ defx#do_action('new_file')
    nnoremap <silent><buffer><expr> d
                \ defx#do_action('remove')
    nnoremap <silent><buffer><expr> r
                \ defx#do_action('rename')
    nnoremap <silent><buffer><expr> x
                \ defx#do_action('execute_system')
    nnoremap <silent><buffer><expr> yy
                \ defx#do_action('yank_path')
    nnoremap <silent><buffer><expr> .
                \ defx#do_action('toggle_ignored_files')
    nnoremap <silent><buffer><expr> h
                \ defx#do_action('cd', ['..'])
    nnoremap <silent><buffer><expr> ~
                \ defx#do_action('cd')
    nnoremap <silent><buffer><expr> q
                \ defx#do_action('quit')
    nnoremap <silent><buffer><expr> <Space>
                \ defx#do_action('toggle_select') . 'j'
    nnoremap <silent><buffer><expr> *
                \ defx#do_action('toggle_select_all')
    nnoremap <silent><buffer><expr> j
                \ line('.') == line('$') ? 'gg' : 'j'
    nnoremap <silent><buffer><expr> k
                \ line('.') == 1 ? 'G' : 'k'
    nnoremap <silent><buffer><expr> <C-l>
                \ defx#do_action('redraw')
    nnoremap <silent><buffer><expr> <C-g>
                \ defx#do_action('print')
    nnoremap <silent><buffer><expr> <CR>
        \ defx#is_directory() ? defx#do_action('open') :
        \ defx#do_action('multi', ['drop'])
        "\ defx#do_action('multi', ['drop', 'quit'])
    "nnoremap <silent><buffer><expr> s
        "\ defx#do_action('multi', [['drop', 'split'], 'quit'])
    "nnoremap <silent><buffer><expr> v
        "\ defx#do_action('multi', [['drop', 'vsplit'], 'quit'])
endfunction
"function! s:defx_mappings() abort
    "nnoremap <silent><buffer>m :call <sid>defx_context_menu()<CR>
    "nnoremap <silent><buffer><expr> o <sid>defx_toggle_tree()
    "nnoremap <silent><buffer><expr> O defx#do_action('open_tree_recursive')
    "nnoremap <silent><buffer><expr> <CR> <sid>defx_toggle_tree()
    "nnoremap <silent><buffer><expr> <2-LeftMouse> <sid>defx_toggle_tree()
    "nnoremap <silent><buffer><expr> C defx#is_directory() ? defx#do_action('multi', ['open', 'change_vim_cwd']) : 'C'
    "nnoremap <silent><buffer><expr> s defx#do_action('open', 'botright vsplit')
    "nnoremap <silent><buffer><expr> R defx#do_action('redraw')
    "nnoremap <silent><buffer><expr> U defx#do_action('multi', [['cd', '..'], 'change_vim_cwd'])
    "nnoremap <silent><buffer><expr> H defx#do_action('toggle_ignored_files')
    "nnoremap <silent><buffer><expr> <Space> defx#do_action('toggle_select') . 'j'
    "nnoremap <silent><buffer><expr> j line('.') == line('$') ? 'gg' : 'j'
    "nnoremap <silent><buffer><expr> k line('.') == 1 ? 'G' : 'k'
    "nnoremap <silent><buffer> J :call search('')<CR>
    "nnoremap <silent><buffer> K :call search('', 'b')<CR>
    "nnoremap <silent><buffer><expr> yy defx#do_action('yank_path')
    "nnoremap <silent><buffer><expr> q defx#do_action('quit')
    "silent exe 'nnoremap <silent><buffer><expr> tt defx#do_action("toggle_columns", "'.s:default_columns.':size:time")'
"endfunction
autocmd VimEnter * exe "Vista|call <sid>defx_open({ 'split': v:true })"
