" File              : default.vim
" Author            : Sun Fu <cstsunfu@gmail.com>
" Date              : 06.08.2019
" Last Modified Date: 06.08.2019
" Last Modified By  : Sun Fu <cstsunfu@gmail.com>
let s:is_win = has('win32')
let $v = $HOME.(s:is_win ? '\vimfiles' : '/.vim')
set relativenumber
set number " 行号显示
let maplocalleader=','
nnoremap \ ;
let mapleader=';' 
inoremap jk <esc>
cnoremap jk <esc>
tnoremap jk <C-\><C-n>

set foldtext=getline(v:foldstart)

if s:is_win
    set shell=cmd.exe
    set shellcmdflag=/c
    set encoding=utf-8
endif

set nobackup
set nowritebackup
set undofile
set swapfile
set history=10000                    " 最大的历史记录数
" 连续可视缩进
xnoremap < <gv
xnoremap > >gv|
nnoremap za zA
"terminal esc
tnoremap <esc> <C-\><C-n>

"{{{ has nvim
if has('nvim')
    set backupdir  -=.
    set shada       ='100
    set fcs=eob:\ 
else
    set backupdir   =$v/files/backup
    set directory   =$v/files/swap/
    set undodir     =$v/files/undo
    set viewdir     =$v/files/view
    set viminfo     ='100,n$v/files/info/viminfo
    "nvim默认设置
    set nocompatible                     " 与Vi不兼容
    filetype plugin indent on            " 对现在的插件是必须的
    syntax on                            " 语法高亮
    set autoindent                       " 沿用上一行缩进
    set autoread                         " 从磁盘自动重载文件
    set backspace=indent,eol,start       " 现代编辑器的退格键行为
    set belloff=all                      " 禁用错误报警声
    set cscopeverbose                    " 详细输出cscope结果
    set complete-=i                      " 补全时，不要对当前被包含的文件进行扫描
    set display=lastline
    "msgsep          " 显示更多消息文本
    set encoding=utf-8                   " 设置默认编码
    set fillchars="fold: ,vert:|"

    " 分隔字符
    set formatoptions=tcqj               " 更直观的自动格式化
    set fsync                            " 调用fsync()实现更健壮的文件保存
    set hlsearch                         " 搜索结果高亮显示
    set incsearch                        " 搜索时边输入边搜索、并移动光标
    set langnoremap                      " 避免出现映射崩溃的情况
    set laststatus=2                     " 总是显示状态栏
    set listchars=tab:>\ ,trail:-,nbsp:+ " :list时一些特殊字符的显示
    set nrformats=bin,hex                " 对<c-a>和<c-x>的支持
    set ruler                            " 在状态栏角落里显示当前行位置信息
    set sessionoptions-=options          " 不同会话不共享选项
    set shortmess=F                      " 文件信息少显示一些
    set showcmd                          " 在状态栏中显示最后一条命令
    set sidescroll=1                     " 更平滑的侧边滚动条
    set smarttab                         " 更智能的<Tab>键响应方式
    set tabpagemax=50                    " -p选项能够打开的最大数目的标签页
    set tags=./tags;,tags                " 用于搜索标签的那些文件名
    set ttimeout
    set ttimeoutlen=50                   " 按键序列中等待下一个的时间，单位为毫
    set ttyfast                          " 要求实现快速的终端连接
    set viminfo+=!                       " 为多个会话保存全局变量
    set wildmenu                         " 增强命令行补全功能
endif
"}}}

set maxmempattern=2000

"开启智能补全
set completeopt=longest,menu
"lazyredraw
set lazyredraw
hi CursorLine term=bold cterm=bold guibg=Grey40
"颜色渲染长度
set synmaxcol=300

filetype plugin on    "自适应不同文件插件不同
set mouse=a
filetype on "开启文件类型侦测
set autochdir    " 自动递归查找
set shellslash   "change
set grepprg=grep\ -nH\ $*
"set shortmess+=c
let g:vimwiki_map_prefix='<leader>o'
let g:tex_flavor = "latex"

set ignorecase
set smartcase        " 智能识别大小写 需要smartcase和ignorecase一起开启
set hidden           " 允许在有未保存的修改时切换缓冲区，此时的修改由 vim 负责保存
syntax enable        "开启语法高亮
syntax on            "允许制定语法高亮替换默认的        


set suffixesadd+=.cpp "搜索文件时自动添加.cpp后缀 即搜索./a ./a.cpp文件可以被搜索出来
"set backup  "生成备份"
"set backupext=.bak

set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936 "encoding
set termencoding=utf-8
set encoding=utf-8

set mouse=a
" 设置编辑时制表符占用空格数
set path+=./** " path增加子目录

" 设置编辑时制表符占用空格数
set tabstop=4
" 将制表符扩展为空格
set expandtab
" 设置格式化时制表符占用空格数
set shiftwidth=4
" 让 vim 把连续数量的空格视为一个制表符
set softtabstop=4

set t_ut=        "避免背景和terminal配色不一样造成显示混乱，disable Backgroud color Erase（BCE）
if has('nvim') || has('termguicolors')
    set termguicolors
endif
" 用tab键来开关折叠
set guioptions-=m    "隐藏菜单栏    
set guioptions-=r   "隐藏右侧滚动条
set guioptions-=T    "隐藏工具栏
set guioptions-=L   "隐藏左侧滚动条

"let g:spchkmouse   = 1
"let g:spchkautonext= 1
"let g:spchkdialect = "usa"
set dictionary=$HOME/.vim/dict/engspchk.dict
set complete+=k  "set complete option

set scrolloff     =4


if !&scrolloff
   set scrolloff=1
endif
if !&sidescrolloff
   set sidescrolloff=5
endif

if &encoding ==# 'latin1' && has('gui_running')
   set encoding=utf-8
endif


if &shell =~# 'fish$' && (v:version < 704 || v:version == 704 && !has('patch276'))
   set shell=/usr/bin/env\ bash
endif


set viewoptions-=options

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^Eterm'
   set t_Co=16
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
   runtime! macros/matchit.vim
endif

" insert keymap like emacs
inoremap <C-w> <C-[>diwa
inoremap <C-h> <BS>
inoremap <C-d> <Del>
inoremap <C-k>  <ESC>d$a
inoremap <C-u> <C-G>u<C-U>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-a> <ESC>^i
inoremap <expr><C-e> pumvisible() ? "\<C-e>" : "\<End>"
"insert a newline
inoremap <C-O> <Esc>o
inoremap <C-S> <esc>:w<CR>
inoremap <C-Q> <esc>:wq<CR>




augroup Smarter_cursorline
    autocmd!
    autocmd InsertLeave,WinEnter,VimEnter,BufEnter,BufWinEnter,BufNew * set cursorline
    "autocmd InsertLeave,WinEnter,VimEnter * set cursorcolumn
    autocmd InsertEnter,WinLeave * set nocursorline
    if has('nvim')
        au TermOpen * setlocal nonumber norelativenumber
    endif
    "au filetype vista setlocal nonumber norelativenumber
    "autocmd InsertEnter,WinLeave * set nocursorcolumn
    autocmd InsertEnter * set norelativenumber
    autocmd InsertLeave * set relativenumber
    autocmd BufReadPost *
                \ if line("'\"") > 1 && line("'\"") <= line("$") |
                \   execute "normal! g`\"" |
                \ endif
augroup END

"""autocmd
"""{{{
"""
 ""   autocmd ColorScheme * source $HOME/.vim/configure/after_set.vim
 ""   augroup autoexe
 ""       autocmd!
 ""       autocmd BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
 ""       autocmd BufReadPre *.tex let b:vimtex_main = 'main.tex'
 ""       autocmd FileType tex nnoremap <leader>fe :LLPStartPreview<cr>
 ""       "autocmd FileType tex setl updatetime=1
 ""       autocmd FileType markdown,vimwiki nnoremap <leader>fe :MarkdownPreview<cr>
 ""       autocmd QuickFixCmdPost * botright copen 8
        autocmd BufWritePost $MYVIMRC source $MYVIMRC

 ""       "autocmd BufRead * :execute "normal! gg=G\<C-o>\<C-o>"
 ""       "autocmd FILETYPE python (do somesthing )
 ""       "需要安装pip3 install yapf 格式化代码工具
 ""       autocmd FileType python nnoremap <Leader>= :0,$!yapf<CR>
 ""       "autocmd FileType beancount inoremap <Tab> <c-x><c-o>
 ""       "autocmd FileType tex,markdown,vimwiki setlocal spell spelllang=en_us,cjk
 ""       "autocmd VimEnter * exe "NERDTreeToggle|wincmd h|TagbarToggle"
 ""       "autocmd VimEnter * exe "TagbarToggle"
 ""       "autocmd VimEnter * exe "Vista"
 ""       "autocmd VimEnter * exe "Vista|call <sid>defx_open( { 'split': v:true })"
 ""       "autocmd VimEnter * exe "Vista|wincmd h|defx_open({ 'split': v:true })"
 ""       "autocmd FileType calendar nmap <buffer> <CR> "\ :<C-u>call vimwiki#diary#calendar_action( b:calendar.day().get_day(), b:calendar.day().get_month(), b:calendar.day().get_year(), b:calendar.day().week(), "V")<CR>
 ""       ""autocmd VimEnter, BufRead * silent exec "hi nontext ctermfg=bg guifg=bg cterm=NONE gui=NONE"
 ""       ""autocmd VimEnter, BufRead * silent exec "hi Normal guibg=NONE ctermbg=NONE"
 ""       ""
 ""       au FileType qf call AdjustWindowHeight(15, 30)
 ""           function! AdjustWindowHeight(minheight, maxheight)
 ""              let l = 1
 ""              let n_lines = 0
 ""              let w_width = winwidth(0)
 ""              while l <= line('$')
 ""                  " number to float for division
 ""                  let l_len = strlen(getline(l)) + 0.0
 ""                  let line_width = l_len/w_width
 ""                  let n_lines += float2nr(ceil(line_width))
 ""                  let l += 1
 ""              endw
 ""              exe max([min([n_lines, a:maxheight]), a:minheight]) . "wincmd _"
 ""           endfunction
 ""   augroup END

"""}}}
