" Select blocks after indenting
xnoremap < <gv
xnoremap > >gv|
nnoremap za zA
"terminal esc
tnoremap <esc> <C-\><C-n>




"lazyredraw
set lazyredraw
set ttyfast

filetype plugin on    "自适应不同文件插件不同
set mouse=a
filetype on "开启文件类型侦测
set autochdir    " 自动递归查找
set shellslash   "change
set grepprg=grep\ -nH\ $*
set nocompatible "禁用vi兼容
set shortmess+=c
set relativenumber
set number  "行号显示
let maplocalleader=','
let mapleader=';' 
nnoremap \ ;
let g:vimwiki_map_prefix='<leader>o'
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
hi VertSplit ctermbg=NONE guibg=NONE
hi VertSplit ctermfg=black guifg=black
hi StatusLine ctermbg=NONE guibg=NONE
hi StatusLine ctermfg=black guifg=black
set fillchars+=vert:│
"set fillchars+=stl:-
"

set hlsearch "高亮搜索结果
set autochdir "显示正确目录
set suffixesadd+=.cpp "搜索文件时自动添加.cpp后缀 即搜索./a ./a.cpp文件可以被搜索出来
"set backup  "生成备份"
"set backupext=.bak
inoremap jk <esc>
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

" 将制表符扩展为空格
set expandtab
" 设置编辑时制表符占用空格数
set tabstop=4
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
nnoremap <tab> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
" 用tab键来开关折叠
set guioptions-=m    "隐藏菜单栏    
set guioptions-=r   "隐藏右侧滚动条
set guioptions-=T    "隐藏工具栏
set guioptions-=L   "隐藏左侧滚动条

"let g:spchkmouse   = 1
"let g:spchkautonext= 1
"let g:spchkdialect = "usa"
set dictionary=/home/sun/.vim/dict/engspchk.dict
set complete-=k  
set complete+=k  "set complete option
