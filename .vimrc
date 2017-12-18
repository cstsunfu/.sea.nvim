" 过时的工具 安装vundle插件管理工具 git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle  
"安装vim-plug 替代vundle    curl -fLo ~/.vim/autoload/plug.vim --create-dirs 
"    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" global mark V
"hi VertSplit guibg=#31312D guifg=#526A83 ctermfg=White ctermbg=Black 
"exe "hi! VertSplit"  .s:fmt_none   .s:fg_red .s:bg_red
"set t_AB=^[[48;5;%dm
"set t_AF=^[[38;5;%dm
"定义快捷键前缀，即<leader>
set lazyredraw
set ttyfast
let maplocalleader=','
let mapleader=';' 
let g:vimwiki_map_prefix='<leader>o'
set ignorecase
set smartcase
"让配置即刻生效
augroup autoexe
   autocmd!
   autocmd QuickFixCmdPost * botright copen 8
   autocmd BufWritePost $MYVIMRC source $MYVIMRC
   "autocmd BufRead * :execute "normal! gg=G\<C-o>\<C-o>"
   "autocmd FILETYPE python (do somesthing )
   autocmd FILETYPE vimwiki,markdown source ~/.vim/myplugin/configure/vimwiki.vim
   "需要安装pip3 install yapf 格式化代码工具
   autocmd FileType python nnoremap <Leader>= :0,$!yapf<CR>
   autocmd FileType calendar nmap <buffer> <CR>
               \ :<C-u>call vimwiki#diary#calendar_action(b:calendar.day().get_day(), b:calendar.day().get_month(), b:calendar.day().get_year(), b:calendar.day().week(), "V")<CR>
   autocmd VimEnter,BufRead * silent exec "hi nontext ctermfg=bg guifg=bg cterm=NONE gui=NONE"
augroup END
nnoremap \ ;
"colorscheme
let python_highlight_all = 1
"if (has("termguicolors"))
       ""set termguicolors
"endif
noremap <C-up>          :colorscheme gruvbox<cr>
noremap <C-left>        :colorscheme space-vim-dark<cr>
noremap <C-down>        :colorscheme solarized<cr>
noremap <C-right>       :colorscheme violet<cr>

set background=dark
"let g:gruvbox_vert_split='dark2'
"colorscheme molokai
"colorscheme violet
"colorscheme gruvbox
colorscheme space-vim-dark
"let g:space_vim_dark_background = 232
"hi Comment cterm=italic
"colorscheme spacemacs-theme
"colorscheme NeoSolarized
"colorscheme solarized
"colorscheme monokai
"================================================================================================================
"set runtimepath+=~/YouCompleteMe
filetype plugin on    "自适应不同文件插件不同
filetype on "开启文件类型侦测
if !has('gui_running')
       "set t_Co=256
endif
set autochdir    " 自动递归查找
set shellslash   "change
set grepprg=grep\ -nH\ $*
set nocompatible "禁用vi兼容
set shortmess+=c
set relativenumber
set number  "行号显示

augroup Smarter_cursorline
    autocmd!
    autocmd InsertLeave,WinEnter,VimEnter * set cursorline
    autocmd InsertLeave,WinEnter,VimEnter * set cursorcolumn
    autocmd InsertEnter,WinLeave * set nocursorline
    autocmd InsertEnter,WinLeave * set nocursorcolumn
augroup END
syntax enable    "开启语法高亮
syntax on        "允许制定语法高亮替换默认的        
set autoindent "自动缩进
"set guifont=YaHei\ Consolas\ Hybrid\ 11.5   "字体， 最后为字大小
"set guifont=DroidSansMono\ Nerd\ Font\ 11
"set guifont=DroidSansMonoForPowerline\ Nerd\ Font\ Book\ 9.5
"highlight VertSplit ctermbg=10 ctermfg=10
"set fillchars+=stl:\ ,stlnc:-,vert:| ,fold:-,diff:- 
"hi VertSplit            ctermfg=LightBlue            ctermbg=Grey
set fillchars+=vert:\        "修改分割线为空格 
set fillchars+=vert:│
"set fillchars+=stl:-
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
"set t_ut=        "避免背景和terminal配色不一样造成显示混乱，disable Backgroud color Erase（BCE）
"set termguicolors
"基于缩进或语法进行代码折叠
set foldmethod=indent
"set foldmethod=syntax
set foldignore=
" 启动vim时关闭代码折叠
set nofoldenable
"za 打开或关闭折叠 zM，关闭所有折叠，zR，打开所有折叠
set guioptions-=m    "隐藏菜单栏    
set guioptions-=r   "隐藏右侧滚动条
set guioptions-=T    "隐藏工具栏
set guioptions-=L   "隐藏左侧滚动条







call plug#begin('~/.vim/plugged')
"git
"Plug 'vim-scripts/VimIM'
Plug 'tpope/vim-jdaddy'
Plug 'goerz/ipynb_notedown.vim'
Plug 'easymotion/vim-easymotion'
Plug 'sheerun/vim-polyglot' "多语言语法支持
let g:polyglot_disabled = ['latex']
Plug 'airblade/vim-gitgutter', {'on' : 'GitGutterEnable'}
Plug 'skywind3000/asyncrun.vim'
Plug 'tpope/vim-fugitive'
Plug 'suan/vim-instant-markdown'
"Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'mbbill/undotree'  "undo tree
Plug 'dyng/ctrlsf.vim'  "ctrlsf from sublime text
Plug 'vim-chat/vim-chat'
Plug 'junegunn/limelight.vim' " light the cursor
Plug 'sk1418/HowMuch' "calculate <leader>?= , <leader>b?  for bc  <leader>p? for python <leader>v? for vim , <leader>?s  appedn the answer, <leader><leader>? for replace,<leader><leader>?s for replace and append,<leader>?=s for append twice
Plug 'mhinz/vim-startify'  " my start page
Plug 'idanarye/vim-vebugger'    "需要vimproc支持 支持很多的语言的debug  vim-debugger
Plug 'joonty/vdebug'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'houtsnip/vim-emacscommandline' "commandline  map  emacs
Plug 'metakirby5/codi.vim'          "caculate the code on the right side use neovim
Plug 'richq/vim-cmake-completion'
Plug 'tpope/vim-abolish'    "enhance  the search by using command 'S' ex. :%S/P{erson,eople}/User{.s}/g
"colorscheme
Plug 'iCyMind/NeoSolarized' "color scheme
Plug 'joshdick/onedark.vim'
Plug 'altercation/vim-colors-solarized'    "solarized配色
Plug 'ashfinal/vim-colors-violet'   "colorscheme violet
Plug 'morhetz/gruvbox'          "spacevim colorscheme
Plug 'colepeters/spacemacs-theme.vim'          "spacemacs colorscheme
Plug 'ajmwagar/vim-deus'
Plug 'liuchengxu/space-vim-dark'        "spacemacs colorscheme
Plug 'tomasr/molokai' "molokai
Plug 'vim-scripts/DrawIt' "画图插件
Plug 'dhruvasagar/vim-table-mode'
Plug 'godlygeek/tabular' "快捷对齐 tabular_con
"vim-org
Plug 'phb1/gtd.vim'
Plug 'wakatime/vim-wakatime'
Plug 'vim-scripts/SyntaxRange'  "suntax highlighting for code blocks
Plug 'plasticboy/vim-markdown'
Plug 'mzlogin/vim-markdown-toc'
Plug 'vimwiki/vimwiki'  "vimwiki
Plug 'vim-scripts/utl.vim'  "universal text link
Plug 'tpope/vim-repeat'     "repeat some action which is not suported as standard vim
Plug 'vim-scripts/taglist.vim'  "taglist
Plug 'tpope/vim-speeddating' "配合org-mode 快速日期操作，sd_con
"Plug 'chrisbra/NrrwRgn'     "narrow region as emacs
Plug 'itchyny/calendar.vim'  "calendar

Plug 'Shougo/denite.nvim'
Plug 'Shougo/unite.vim'   " unite  
Plug 'ujihisa/unite-colorscheme'
Plug 'Shougo/neomru.vim'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
"Plug 'neoclide/todoapp.vim'
"Plug 'sgur/unite-everything'

Plug 'terryma/vim-multiple-cursors' "multi_cur_con
Plug 'tpope/vim-surround' "添加surround
"用法：cs"'   ds"   ysiw' ysiw<tag> yss'
Plug 'lambdalisue/vim-fullscreen'  "全屏插件
Plug 'vim-scripts/Auto-Pairs'
Plug 'lervag/vimtex' "latex


"Plug 'begriffs/haskell-vim-now'
Plug 'neovimhaskell/haskell-vim', {'for' : 'haskell'}
Plug 'nathanaelkane/vim-indent-guides'  "代码缩进关联插件，即同一级的代码关联  indent_con
Plug 'ianva/vim-youdao-translater'    "trans_con  youdao dictionary
Plug 'SirVer/ultisnips'    "usnip_con
Plug 'honza/vim-snippets'
Plug 'ervandew/supertab'    "supertab 
Plug 'rdnetto/YCM-Generator' "generator the ycm_extra_conf.py
Plug 'octol/vim-cpp-enhanced-highlight' "cpp高亮加强查件
"vim-cpp-enhanced-highlight 主要通过
".vim/bundle/vim-cpp-enhanced-highlight/after/syntax/cpp.vim
"控制高亮关键字及规则，所以，当你发现某个 STL
"容器类型未高亮，那么将该类型追加进 cpp.vim 即可。如，initializer_list
"默认并不会高亮，需要添加 syntax keyword cppSTLtype initializer_list
"Plug 'xolox/vim-misc'
Plug 'hdima/python-syntax'  "python syntax enhance
Plug 'kshenoy/vim-signature'    "显示书签标记 m+字母标记 `+书签标记跳转
" 书签设定。mx，设定/取消当前行名为 x 的标签；m,，自动设定下一个可用书签名，前面提说，独立书签名是不能重复的，在你已经有了多个独立书签，当想再设置书签时，需要记住已经设定的所有书签名，否则很可能会将已有的书签冲掉，这可不好，所以，vim-signature 为你提供了 m, 快捷键，自动帮你选定下一个可用独立书签名；mda，删除当前文件中所有独立书签。
"书签罗列。m?，罗列出当前文件中所有书签，选中后回车可直接跳转；
"书签跳转。mn，按行号前后顺序，跳转至下个独立书签；mp，按行号前后顺序，跳转至前个独立书签。书签跳转方式很多，除了这里说的行号前后顺序，还可以基于书签名字母顺序跳转、分类书签同类跳转、分类书签不同类间跳转等等。 
Plug 'majutsushi/tagbar'    "基于标签的标识符列表插件 配置见tagbar_configure
"Plug 'tenfyzhong/CompleteParameter.vim'         "配合ycm使用
"inoremap <silent><expr> ( complete_parameter#pre_complete("()")
"smap <c-j> <Plug>(complete_parameter#goto_next_parameter)
"imap <c-j> <Plug>(complete_parameter#goto_next_parameter)
"smap <c-k> <Plug>(complete_parameter#goto_previous_parameter)
"imap <c-k> <Plug>(complete_parameter#goto_previous_parameter)

function! BuildYCM(info)
   if a:info.status == 'installed' || a:info.force
       !./install.sh
   endif
endfunction
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
"Plug 'rkulla/pydiction' "补全特定python库
"Plug 'tenfyzhong/CompleteParameter.vim'
"Plug 'w0rp/ale'     "syntax check
Plug 'vim-scripts/DfrankUtil'     "indexer depend on
Plug 'vim-scripts/vimprj'            "indexer depend on
Plug 'vim-scripts/indexer.tar.gz' "Plugin indexer  自动生成标签用的
"indexer 插件配置 位于 indexer_con
Plug 'scrooloose/nerdcommenter'    "快速注释插件 配置见 ner_con
Plug 'vim-scripts/winmanager'     "文件浏览器WinManager_con
Plug 'moll/vim-bbye'        "when you close the buffer the window could be reserve
Plug 'scrooloose/nerdtree'       "nt_con list the files in the same dirrectory
Plug 'lilydjwg/fcitx.vim'   "中文输入加持，需要将ttimeoutlen设置为较小的值

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'dracula/vim' "theme
Plug 'kristijanhusak/vim-hybrid-material' "theme
Plug 'sonph/onehalf', {'rtp': 'vim/'} "theme
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'


"Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
" (Optional) Showing function signature and inline doc.
"Plug 'Shougo/echodoc.vim'

call plug#end()


source ~/.vim/myplugin/configure/vim_unite.vim
source ~/.vim/myplugin/configure/mystart.vim
source ~/.vim/myplugin/configure/calendar.vim
"source ~/.vim/myplugin/configure/myauto.vim
source ~/.vim/myplugin/configure/myshortcut.vim

"TODO
""编译"
"" F5编译和运行C程序，F6编译和运行C++程序
"" 请注意，下述代码在windows下使用会报错
"" 需要去掉./这两个字符
"" C的编译和运行
noremap <F5> :call CompileRun()<CR>
func! CompileRun()
    if &filetype=="tex"
        exec "w"
        silent exec "!rm %<.pdf"
        exec "!xelatex %<"
        "exec "!dvipdfm %<"
        silent exec "!rm %<.aux %<.dvi %<.toc %<.log %<.snm %<.nav %<.out"
        silent exec "!evince %<.pdf"
        silent exec "!rm %<.aux %<.dvi %<.toc %<.log %<.snm %<.nav %<.out"
    endif
    if &filetype=="python"

        exec "AsyncRun python3 %"

        "redir => message
        "let filename = expand("%")
        "exec "split python.output"
        "silent exec "read !python3 " filename

        ""redir END
        ""silent exec 
        ""silent put=message
        ""set nomodified
    endif
    if &filetype=="c"
        exec "w"
        exec "AsyncRun gcc -Wall -g % -o %<"
        exec "AsyncRun ./%<"
    endif
    if &filetype=="cpp"
        exec "w"
        exec "AsyncRun g++ -Wall -g % -o %<"
        "exec "cw"
        exec "AsyncRun ./%<"
    endif
    if &filetype=="dot"
        exec "w"
        exec "!dot -Tpng -o %<.png % && start %<.png"
    endif
endfunction
augroup autodot
   autocmd!
   autocmd BufRead *.dot nnoremap <F8> :w<CR>:!dot -Tpng -o %<.png % && start %<.png<CR><CR>
augroup END




"
"============================================================================================================================================
"插件配置
"visul star
"*查找当前选择的文本 #反向  也可以通过visul star search 插件实现
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>
function! s:VSetSearch()
   let temp =@s
   norm! gv"sy
   let @/ = '\V' . substitute(escape(@s,'/\'),'\n','\\n', 'g')
   let @s = temp
endfunction


"===================================================================================================================
"complete
"vim命令行模式智能补全
"YouCompleteMe
set wildmenu 
"开启智能补全
set completeopt=longest,menu
"ycm_con
"let g:ycm_filetype_whitelist = { 'cpp': 1, 'c': 1 }    "why?
"let g:ycm_error_symbol = '>>'
let g:ycm_global_ycm_extra_conf='~/.vim/plugged/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
let g:ycm_python_binary_path = '/usr/bin/python3'
"ycm插件 用于声明/定义跳转
let g:pydiction_location = '/home/sun/.vim/plugged/pydiction/complete-dict'
nnoremap <leader>gc :YcmCompleter GoToDeclaration<CR>
" 只能是 #include 或已打开的文件
nnoremap <leader>gd :YcmCompleter GoToDefinition<CR>
inoremap <leader>; <C-x><C-o>
" 补全功能在注释中同样有效
let g:ycm_complete_in_comments=1
" 允许 vim 加载 .ycm_extra_conf.py 文件，不再提示
let g:ycm_confirm_extra_conf=0
" 开启 YCM 标签补全引擎
let g:ycm_collect_identifiers_from_tags_files=1
" 引入 C++ 标准库tags
"set tags+=/usr/include/c++/6.4.1/stdcpp.tags
" YCM 集成 OmniCppComplete 补全引擎，设置其快捷键
inoremap <leader>; <C-x><C-o>
" 补全内容不以分割子窗口形式出现，只显示补全列表
"set completeopt-=preview
" 从第一个键入字符就开始罗列匹配项
let g:ycm_min_num_of_chars_for_completion=1
" 禁止缓存匹配项，每次都重新生成匹配项
"let g:ycm_cache_omnifunc=0
" 语法关键字补全            
let g:ycm_seed_identifiers_with_syntax=1
let g:jedi#completions_enabled=0
" YCM 补全菜单配色
" 菜单
"highlight Pmenu ctermfg=15 ctermbg=0 guifg=#FFFFE0 guibg=#8B795E
"" 选中项
"highlight PmenuSel ctermfg=2 ctermbg=3 guifg=#0D0D0D guibg=#C0FF3E

"indexer_con and tags
"let g:tagbar_ctags_bin='~/.vim/ctags'    "ctags目录  再将ctags.exe放到vim执行文件处，这样不必修改环境变量 windows里面的 address:http://ctags.sourceforge.net/ 
"set tags=tags;   "如果未安装indexer需要加
"set tags+=./tags
" 设置插件 indexer 调用 ctags 的参数
" 默认 --c++-kinds=+p+l，重新设置为 --c++-kinds=+p+l+x+c+d+e+f+g+m+n+s+t+u+v
" 默认 --fields=+iaS 不满足 YCM 要求，需改为 --fields=+iaSl
let g:indexer_ctagsCommandLineOptions="--c++-kinds=+p+l+x+c+d+e+f+g+m+n+s+t+u+v --fields=+iaSl --extra=+q"
"另外，indexer 还有个自己的配置文件，用于设定各个工程的根目录路径，配置文件位于 ~/.indexer_files，内容可以设定为：
"
"--------------- ~/.indexer_files ---------------  
"[foo] 
"/data/workplace/foo/src/
"[bar] 
"/data/workplace/bar/src/
"上例设定了两个工程的根目录，方括号内是对应工程名，路径为工程的代码目录，不要包含构建目录、文档目录，以避免将产生非代码文件的标签信息。这样，从以上目录打开任何代码文件时，indexer 便对整个目录创建标签文件，若代码文件有更新，那么在文件保存时，indexer 将自动调用 ctags 更新标签文件，indexer 生成的标签文件以工程名命名，位于 ~/.indexer_files_tags/，并自动引入进 vim 中，那么
"---------------------~/.indexer_files -----------------------
"[PROJECTS_PARENTfilter="*.c *.h *.cpp"] 
"~/workspace
"
":set tags+=/data/workplace/example/tags
"一步也省了
"======================================================================================================================================

"indent_con
"indent_con配置
"随vim自启动
let g:indent_guides_enable_on_vim_startup=1
"从第二层开始可视化显示缩进
let g:indent_guides_start_level=2
"色块宽度
let g:indent_guides_guide_size=1
"快捷键i 开/关缩进可视化
nnoremap <silent> <leader>ii :IndentGuidesToggle<cr>
let g:indent_guides_exclude_filetypes = ['calendar', 'startify']




" tagbar_configure
" 设置 tagbar 子窗口的位置出现在主编辑区的左边 
let tagbar_left=1 
" 设置显示／隐藏标签列表子窗口的快捷键。速记：identifier list by tag
nnoremap <leader>ilt :TagbarToggle<CR> 
" 设置标签子窗口的宽度 
let tagbar_width=18 
" tagbar 子窗口中不显示冗余帮助信息 
let g:tagbar_compact=1
" 设置 ctags 对哪些代码标识符生成标签
let g:tagbar_type_cpp = {
           \ 'kinds' : [
           \ 'c:classes:0:1',
           \ 'd:macros:0:1',
           \ 'e:enumerators:0:0', 
           \ 'f:functions:0:1',
           \ 'g:enumeration:0:1',
           \ 'l:local:0:1',
           \ 'm:members:0:1',
           \ 'n:namespaces:0:1',
           \ 'p:functions_prototypes:0:1',
           \ 's:structs:0:1',
           \ 't:typedefs:0:1',
           \ 'u:unions:0:1',
           \ 'v:global:0:1',
           \ 'x:external:0:1'
           \ ],
           \ 'sro'        : '::',
           \ 'kind2scope' : {
           \ 'g' : 'enum',
           \ 'n' : 'namespace',
           \ 'c' : 'class',
           \ 's' : 'struct',
           \ 'u' : 'union'
           \ },
           \ 'scope2kind' : {
           \ 'enum'      : 'g',
           \ 'namespace' : 'n',
           \ 'class'     : 'c',
           \ 'struct'    : 's',
           \ 'union'     : 'u'
           \ }
           \ }



" UltiSnips 的 tab 键与 YCM 冲突，重新设定
let g:UltiSnipsExpandTrigger="<leader><tab>"
let g:UltiSnipsJumpForwardTrigger="<leader><tab>"
let g:UltiSnipsJumpBackwardTrigger="<leader><s-tab>"
let g:snips_author= 'Sun Fu'
let g:snips_email= 'cstsunfu@gmail.com'
let g:snips_github= 'https://github.com/cstsunfu'
let g:snips_wechat= 'cstsunfu'



" 设置NERDTree子窗口宽度
let NERDTreeWinSize=18
" 设置NERDTree子窗口位置
let NERDTreeWinPos="right"
" 显示隐藏文件
let NERDTreeShowHidden=1
" NERDTree 子窗口中不显示冗余帮助信息
let NERDTreeMinimalUI=1
" 删除文件时自动删除文件对应 buffer
let NERDTreeAutoDeleteBuffer=1
let NERDTreeIgnore=['\.o$','\.hi', '\.docs$', '\.doc$', '\.pdf$', '\~$']


"airline
"这个是安装字体后 必须设置此项" 
let g:airline_powerline_fonts = 1   
let g:airline#extensions#tabline#fnamemod = ':t'
"打开tabline功能,方便查看Buffer和切换,省去了minibufexpl插件
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline_theme='onedark'
"let g:airline_theme='base16'
let g:airline#extensions#ale#enabled = 1    "ale error or warning
"airline set the window number
function! WindowNumber(...)
   let builder = a:1
   let context = a:2
   call builder.add_section('airline_b', '%{tabpagewinnr(tabpagenr())}')
   return 0
endfunction

augroup window_number
    autocmd!
    autocmd VimEnter  * call airline#add_statusline_func('WindowNumber')
    autocmd VimEnter  * call airline#add_inactive_statusline_func('WindowNumber')
augroup END

"ale_con
"let g:ale_sign_column_always = 1
"let g:ale_set_highlights = 1
"自定义error和warning图标
let g:ale_sign_error = '●'
let g:ale_sign_warning = '○'
"在vim自带的状态栏中整合ale
let g:ale_statusline_format = ['● %d', '○ %d', '✔ OK']
"显示Linter名称,出错或警告等相关信息
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
"文件内容不发生变化时不进行检查
let g:ale_lint_on_text_changed = 'never'
"打开文件时进行检查
let g:ale_lint_on_enter = 0
" quickfix display the errore
"let g:ale_set_loclist = 0
"let g:ale_set_quickfix = 1
"let g:ale_open_list = 1
let g:ale_python_flake8_executable = 'python3'   " or 'python' for Python 2
let g:ale_python_mypy_executable = 'python3'
let g:ale_python_flake8_options = '-m flake8'
" Set this if you want to.
" This can be useful if you are combining ALE with
" some other plugin which sets quickfix errors, etc.
"let g:ale_keep_list_window_open = 1
"下面两行配置与F功能键冲突
"nnoremap <silent> <C-]> :ALENext<cr>
"nnoremap <silent> <C-[> :ALEPrevious<cr>

"vimwiki
"let g:vimwiki_list = [{'path': '~/vimwiki/',
                  "\ 'syntax': 'markdown', 'ext': '.wiki'}]

"hi VertSplit guibg=#282828 guifg=#181A1F
"hi VertSplit ctermbg=NONE guibg=NONE
"let g:gruvbox_contrast_light='medium'   "soft medium hard

" Color name (:help cterm-colors) or ANSI code
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240


let wiki_1 = {}
let wiki_1.path = '~/vimwiki/'
let wiki_1.syntax='markdown'
let wiki_1.ext='.wiki'
let wiki_1.html_template = '~/public_html/template.tpl'
let wiki_1.nested_syntaxes = {'python': 'python', 'c++': 'cpp'}

let wiki_2 = {}
let wiki_2.path = '~/project_docs/'
let wiki_2.index = 'main'
let g:vimwiki_list = [wiki_1, wiki_2]



call denite#custom#map(
     \ 'insert',
     \ '<C-n>',
     \ '<denite:move_to_next_line>',
     \ 'noremap'
     \)
call denite#custom#map(
     \ 'insert',
     \ '<C-p>',
     \ '<denite:move_to_previous_line>',
     \ 'noremap'
     \)


"highlight SignColumn ctermbg=black
highlight clear SignColumn
"highlight SignColumn guibg=darkgrey
highlight clear ALEErrorSign
highlight clear ALEWarningSign

nnoremap <F2> i<esc>:w !python %<cr>
nnoremap <F3> i<esc>:w !python3 %<cr>



"latex
let g:tex_flavor='latex'
let g:Tex_CompileRule_pdf = 'latex $*'
let g:Tex_ViewRule_pdf = 'evince'
set mouse=a

"gtd
let g:gtd#dir = '~/.vim/notes'
let g:gtd#default_context = 'work'
let g:gtd#default_action = 'todo'
let g:gtd#review = [
    \ '(!inbox + !scheduled-'.strftime("%Y%m%d").') @work',
    \ '!todo @work',
    \ '!waiting @work',
    \ ]
nnoremap <Leader>oa :Gtd @work (!inbox + !scheduled-<C-R>=strftime("%Y%m%d")<CR>)<CR>
nnoremap <Leader>on :GtdNew<CR>


"easymotion

" <Leader>f{char} to move to {char}
map  <Leader>mf <Plug>(easymotion-bd-f)
nmap <Leader>mf <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)

" Move to line
map <Leader>ml <Plug>(easymotion-bd-jk)
nmap <Leader>ml <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>mw <Plug>(easymotion-bd-w)
nmap <Leader>mw <Plug>(easymotion-overwin-w)



