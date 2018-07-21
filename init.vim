" File              : init.vim
" Author            : Sun Fu <cstsunfu@gmail.com>
" Date              : 20.06.2018
" Last Modified Date: 21.07.2018
" Last Modified By  : Sun Fu <cstsunfu@gmail.com>
set runtimepath^=~/.vim runtimepath+=~/.vim/after
set runtimepath^=~/.vim/myplugin
let &packpath = &runtimepath
let &rtp  = '~/.vim/plugged/vimtex,' . &rtp
let &rtp .= ',~/.vim/plugged/vimtex/after'
let g:python3_host_prog = '/Users/sun/anaconda3/bin/python3'
let g:python2_host_prog = '/usr/bin/python2.7'
source ~/.vim/myplugin/configure/default.vim
"=============================================================================================================
"normal configure
"=============================================================================================================

"=============================================================================================================
"autocmd
    augroup Smarter_cursorline
        autocmd!
        autocmd InsertLeave,WinEnter,VimEnter * set cursorline
        "autocmd InsertLeave,WinEnter,VimEnter * set cursorcolumn
        autocmd InsertEnter,WinLeave * set nocursorline
        autocmd InsertEnter,WinLeave * set nocursorcolumn
    augroup END
    augroup autoexe
        autocmd!
        autocmd BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
        autocmd BufReadPre *.tex let b:vimtex_main = 'main.tex'
        autocmd FileType tex map <leader>fe :LLPStartPreview<cr>
        "autocmd FileType markdown,vimwiki map <leader>fe :InstantMarkdownPreview<cr>
        autocmd QuickFixCmdPost * botright copen 8
        autocmd BufWritePost $MYVIMRC source $MYVIMRC
        "autocmd BufRead * :execute "normal! gg=G\<C-o>\<C-o>"
        "autocmd FILETYPE python (do somesthing )
        "autocmd FILETYPE vimwiki,markdown source ~/.vim/myplugin/configure/vimwiki.vim
        "需要安装pip3 install yapf 格式化代码工具
        autocmd FileType python nnoremap <Leader>= :0,$!yapf<CR>
        autocmd VimEnter * exe "NERDTreeToggle|wincmd h|TagbarToggle"
        autocmd FileType calendar nmap <buffer> <CR>
                    \ :<C-u>call vimwiki#diary#calendar_action(b:calendar.day().get_day(), b:calendar.day().get_month(), b:calendar.day().get_year(), b:calendar.day().week(), "V")<CR>
        "autocmd VimEnter,BufRead * silent exec "hi nontext ctermfg=bg guifg=bg cterm=NONE gui=NONE"
        "autocmd VimEnter,BufRead * silent exec "hi Normal guibg=NONE ctermbg=NONE"
    augroup END
"=============================================================================================================

"=============================================================================================================
"color
    noremap <C-up>          :colorscheme gruvbox<cr>
    noremap <C-left>        :colorscheme space-vim-dark<cr>
    noremap <C-down>        :colorscheme solarized<cr>
    noremap <C-right>       :colorscheme violet<cr>

    let python_highlight_all = 1
    set background=dark
    let themes = ['gruvbox', 'space-vim-dark']
    "execute 'colorscheme '.themes[localtime() % len(themes)]
    "unlet themes
    "let g:gruvbox_vert_split='dark2'
    "colorscheme molokai
    "colorscheme violet
    colorscheme gruvbox
    "colorscheme space-vim-dark
    "let g:space_vim_dark_background = 232
    "hi Comment cterm=italic
    "colorscheme spacemacs-theme
    "colorscheme NeoSolarized
    "colorscheme solarized
    "colorscheme monokai
"================================================================================================================
call plug#begin('~/.vim/plugged')
    Plug 'scrooloose/nerdcommenter'    "快速注释插件 配置见 ner_con

    Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
    Plug 'sophAi/vim-ipython_py3',{'for': 'python'}
    Plug 'AndrewRadev/linediff.vim' , { 'on': [ 'Linediff', 'LinediffReset' ] }
    Plug 'easymotion/vim-easymotion'
    Plug 'sheerun/vim-polyglot' "多语言语法支持
        let g:polyglot_disabled = ['latex']
    Plug 'airblade/vim-gitgutter', {'on' : 'GitGutterEnable'}
    Plug 'zenbro/mirror.vim'
    Plug 'skywind3000/asyncrun.vim'
    Plug 'tpope/vim-fugitive'
    function! BuildComposer(info)
      if a:info.status != 'unchanged' || a:info.force
        if has('nvim')
          !cargo build --release
        else
          !cargo build --release --no-default-features --features json-rpc
        endif
      endif
    endfunction
    Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
    Plug 'xuhdev/vim-latex-live-preview',{'for': 'tex'}
        let g:livepreview_previewer = 'open'
        let g:livepreview_engine = 'xelatex'
        set updatetime=1000
    Plug 'plasticboy/vim-markdown'
    Plug 'mzlogin/vim-markdown-toc'
    Plug 'lervag/vimtex'
        ""vimtex
        "let g:vimtex_quickfix_ignored_warnings   = []
        ""      \ 'Underfull',
        ""      \ 'Overfull',
        ""      \ 'specifier changed to',
        ""      \ 'Package mpgraphics Warning',
        ""       \]
        let g:tex_flavor                          = 'latex'
        let g:vimtex_quickfix_mode             = 2
        let g:vimtex_latexmk_options              = '-xelatex -verbose -file-line-error -synctex=1 -shell-escape -interaction=nonstopmode' 
        let g:vimtex_view_general_viewer          = 'open'
        "let g:vimtex_view_general_options         = '-reuse-instance -inverse-search "\"' . $VIMRUNTIME . '\gvim.exe\" -n --remote-silent +\%l \"\%f\"" -forward-search @tex @line @pdf'
        let g:vimtex_compiler_method = 'latexmk'
        "let g:vimtex_view_general_options_latexmk = '-reuse-instance'
        let g:vimtex_compiler_progname = 'nvr'

    Plug 'mbbill/undotree',{'on':'UndotreeToggle'}  "undo tree
    Plug 'dyng/ctrlsf.vim'  "ctrlsf from sublime text
    Plug 'junegunn/limelight.vim' " light the cursor
    Plug 'sk1418/HowMuch' 
        "calculate <leader>?= , <leader>b?  for bc  <leader>p? for python <leader>v? for vim , <leader>?s  appedn the answer, <leader><leader>? for replace,<leader><leader>?s for replace and append,<leader>?=s for append twice
    Plug 'mhinz/vim-startify'  " my start page
    Plug 'alpertuna/vim-header' 
        let g:header_auto_add_header = 1
        let g:header_field_author = 'Sun Fu'
        let g:header_field_author_email = 'cstsunfu@gmail.com'
    Plug 'idanarye/vim-vebugger'    "需要vimproc支持 支持很多的语言的debug  vim-debugger
    Plug 'Shougo/vimproc.vim', {'do' : 'make'}
    Plug 'houtsnip/vim-emacscommandline' "commandline  map  emacs
    Plug 'metakirby5/codi.vim'          "caculate the code on the right side use neovim
    Plug 'richq/vim-cmake-completion'
    Plug 'tpope/vim-abolish'    "enhance  the search by using command 'S' ex. :%S/P{erson,eople}/User{.s}/g
    Plug 'vim-scripts/DrawIt' "画图插件
    Plug 'dhruvasagar/vim-table-mode'
    Plug 'godlygeek/tabular' "快捷对齐 tabular_con
    "vim-org
    Plug 'phb1/gtd.vim'
        "gtd
        let g:gtd#dir = '~/.vim/notes'
        let g:gtd#default_context = 'work'
        let g:gtd#default_action = 'todo'
        let g:gtd#review = [
                    \ '(!inbox + !scheduled-'.strftime("%Y%m%d").') @work',
                    \ '!todo @work',
                    \ '!waiting @work',
                    \ ]
    Plug 'wakatime/vim-wakatime'
    Plug 'vim-scripts/SyntaxRange'  "suntax highlighting for code blocks
    Plug 'vimwiki/vimwiki'  "vimwiki
    Plug 'powerman/vim-plugin-AnsiEsc'
    "Plug 'blindFS/vim-taskwarrior'
    "Plug 'tbabej/taskwiki'
        ""vimwiki
        ""let g:vimwiki_list = [{'path': '~/vimwiki/',
        ""\ 'syntax': 'markdown', 'ext': '.wiki'}]
        "let wiki_1 = {}
        "let wiki_1.path = '~/vimwiki/'
        "let wiki_1.auto_tags = 1
        "let wiki_1.syntax='markdown'
        "let wiki_1.ext='.md'
        "let wiki_1.html_template = '~/public_html/template.tpl'
        "let wiki_1.nested_syntaxes = {'python': 'python', 'c++': 'cpp'}

        "let wiki_2 = {}
        "let wiki_2.path = '~/project_docs/'
        "let wiki_2.index = 'main'
        "let g:vimwiki_list = [wiki_1, wiki_2]

    Plug 'vim-scripts/utl.vim'  "universal text link
    Plug 'tpope/vim-repeat'     "repeat some action which is not suported as standard vim
    Plug 'vim-scripts/taglist.vim'  "taglist
    Plug 'tpope/vim-speeddating' "配合org-mode 快速日期操作，sd_con
    Plug 'itchyny/calendar.vim',{'on':'Calendar'}  "calendar

    Plug 'Shougo/denite.nvim'
    Plug 'Shougo/unite.vim'   " unite  
    Plug 'ujihisa/unite-colorscheme'
    Plug 'Shougo/neomru.vim'
    Plug 'Shougo/vimproc.vim', {'do' : 'make'}

    Plug 'terryma/vim-multiple-cursors' "multi_cur_con
    Plug 'tpope/vim-surround' "添加surround
    "用法：cs"'   ds"   ysiw' ysiw<tag> yss'
    Plug 'vim-scripts/Auto-Pairs'

    Plug 'Yggdroot/indentLine'
        " 与latex有冲突，该插件会使tex文件的数学符号直接显示出来
        let g:indentLine_fileTypeExclude = ['tex']
    Plug 'ianva/vim-youdao-translater',{'on':'Yde'}    "trans_con  youdao dictionary
    Plug 'SirVer/ultisnips'    "usnip_con
        "ultisnips
        " UltiSnips 的 tab 键与 YCM 冲突，重新设定
        let g:UltiSnipsExpandTrigger="<leader><tab>"
        let g:UltiSnipsJumpForwardTrigger="<leader><tab>"
        let g:UltiSnipsJumpBackwardTrigger="<leader><s-tab>"
        let g:snips_author= 'Sun Fu'
        let g:snips_email= 'cstsunfu@gmail.com'
        let g:snips_github= 'https://github.com/cstsunfu'
        let g:snips_wechat= 'cstsunfu'
    Plug 'cstsunfu/vim-snippets'
    Plug 'ervandew/supertab'    "supertab 
    Plug 'octol/vim-cpp-enhanced-highlight',{'for':'cpp'} "cpp高亮加强查件
    "vim-cpp-enhanced-highlight 主要通过
    ".vim/bundle/vim-cpp-enhanced-highlight/after/syntax/cpp.vim
    "控制高亮关键字及规则，所以，当你发现某个 STL
    "容器类型未高亮，那么将该类型追加进 cpp.vim 即可。如，initializer_list
    "默认并不会高亮，需要添加 syntax keyword cppSTLtype initializer_list
    Plug 'hdima/python-syntax', {'for':'python'}  "python syntax enhance
    Plug 'kshenoy/vim-signature'    "显示书签标记 m+字母标记 `+书签标记跳转
    " 书签设定。mx，设定/取消当前行名为 x 的标签；m,，自动设定下一个可用书签名，前面提说，独立书签名是不能重复的，在你已经有了多个独立书签，当想再设置书签时，需要记住已经设定的所有书签名，否则很可能会将已有的书签冲掉，这可不好，所以，vim-signature 为你提供了 m, 快捷键，自动帮你选定下一个可用独立书签名；mda，删除当前文件中所有独立书签。
    "书签罗列。m?，罗列出当前文件中所有书签，选中后回车可直接跳转；
    "书签跳转。mn，按行号前后顺序，跳转至下个独立书签；mp，按行号前后顺序，跳转至前个独立书签。书签跳转方式很多，除了这里说的行号前后顺序，还可以基于书签名字母顺序跳转、分类书签同类跳转、分类书签不同类间跳转等等。 
    Plug 'vim-scripts/DfrankUtil'     "indexer depend on
    Plug 'vim-scripts/vimprj'            "indexer depend on
    Plug 'vim-scripts/indexer.tar.gz' "Plugin indexer  自动生成标签用的
    "indexer 插件配置 位于 indexer_con
    Plug 'vim-scripts/winmanager'     "文件浏览器WinManager_con
    Plug 'moll/vim-bbye'        "when you close the buffer the window could be reserve
    Plug 'scrooloose/nerdtree',{'on':'NERDTreeToggle'}       "nt_con list the files in the same dirrectory
    Plug 'jistr/vim-nerdtree-tabs'
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
"theme & beauty
    Plug 'myusuf3/numbers.vim'
    Plug 'ryanoasis/vim-devicons'
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
    Plug 'vim-airline/vim-airline'
        "airline
        "这个是安装字体后 必须设置此项" 
        let g:airline_powerline_fonts = 1   
        let g:airline#extensions#tabline#fnamemod = ':t'
        "打开tabline功能,方便查看Buffer和切换,省去了minibufexpl插件
        let g:airline#extensions#tabline#enabled = 1
        let g:airline#extensions#tabline#buffer_nr_show = 1
        let g:airline#extensions#tabline#buffer_idx_mode = 1
        "let g:airline_theme='onedark'
        "let g:airline_theme='gruvbox'
        "let g:airline_theme='zenburn'
        if g:colors_name == 'space-vim-dark'
            "let g:airline_theme=''
            let g:airline_theme='violet'
        endif

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
            "autocmd VimEnter  * call airline#add_statusline_func('WindowNumber')
            "autocmd VimEnter  * call airline#add_inactive_statusline_func('WindowNumber')
        augroup END
    Plug 'vim-airline/vim-airline-themes'
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

"complete & code
    Plug 'w0rp/ale'     "syntax check
        "ale_con
        "highlight SignColumn ctermbg=black
        highlight clear SignColumn
        "highlight SignColumn guibg=darkgrey
        highlight clear ALEErrorSign
        highlight clear ALEWarningSign
        "let g:ale_sign_column_always = 1
        "let g:ale_set_highlights = 1
        "自定义error和warning图标
        let g:ale_sign_error = '●'
        let g:ale_sign_warning = '○'
        "在vim自带的状态栏中整合ale
        let g:ale_statusline_format = ['● %d', '○ %d', '✔ OK']
        "显示Linter名称,出错或警告等相关信息
        let g:ale_echo_msg_error_str = '✗'
        let g:ale_echo_msg_warning_str = 'W'
        let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
        "文件内容不发生变化时不进行检查
        "let g:ale_lint_on_text_changed = 'never'
        "打开文件时进行检查
        let g:ale_lint_on_enter = 1
        " quickfix display the errore
        "let g:ale_set_loclist = 0
        "let g:ale_set_quickfix = 1
        "let g:ale_open_list = 1
        let g:ale_python_flake8_executable = 'python3'   " or 'python' for Python 2
        let g:ale_python_mypy_executable = 'python3'
        let g:ale_python_flake8_options = '-m flake8'
        "let g:ale_python_flake8_options = '--max-line-length 12'
        let g:ale_linters = {'python': ['flake8']}
        "let g:max_line_length=120
        " Set this if you want to.
        " This can be useful if you are combining ALE with
        " some other plugin which sets quickfix errors, etc.
        "let g:ale_keep_list_window_open = 1
        "下面两行配置与F功能键冲突
        "nnoremap <silent> <C-]> :ALENext<cr>
        "nnoremap <silent> <C-[> :ALEPrevious<cr>
    Plug 'majutsushi/tagbar'    "基于标签的标识符列表插件 配置见tagbar_configure
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
    Plug 'tenfyzhong/CompleteParameter.vim'         "配合ycm使用
        "inoremap <silent><expr> ( complete_parameter#pre_complete("()")
        "smap <c-j> <Plug>(complete_parameter#goto_next_parameter)
        "imap <c-j> <Plug>(complete_parameter#goto_next_parameter)
        "smap <c-k> <Plug>(complete_parameter#goto_previous_parameter)
        "imap <c-k> <Plug>(complete_parameter#goto_previous_parameter)
    Plug 'rdnetto/YCM-Generator' "generator the ycm_extra_conf.py
    "function! BuildYCM(info)
        "if a:info.status == 'installed' || a:info.force
            "!./install.sh
        "endif
    "endfunction
    "Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
    Plug 'tpope/vim-jdaddy'
    "Plug 'tenfyzhong/CompleteParameter.vim'
        "inoremap <silent><expr> ( complete_parameter#pre_complete("()")
        "let g:AutoPairs = {'[':']', '{':'}',"'":"'",'"':'"', '`':'`'}
        "smap <c-j> <Plug>(complete_parameter#goto_next_parameter)
        "imap <c-j> <Plug>(complete_parameter#goto_next_parameter)
        "smap <c-k> <Plug>(complete_parameter#goto_previous_parameter)
        "imap <c-k> <Plug>(complete_parameter#goto_previous_parameter)
    Plug 'Valloric/YouCompleteMe'
        "===================================================================================================================
        "complete
            "vim命令行模式智能补全
            "YouCompleteMe
            set wildmenu 
            "开启智能补全
            set completeopt=longest,menu
            "ycm_con
            let g:ycm_filetype_whitelist = { 'cpp': 1, 'c': 1,'python': 1,'tex': 1}    "why?
            "let g:ycm_filetype_blacklist = { 'cpp': 1, 'c': 1,'python': 1,'tex': 1}    "why?
            "let g:ycm_error_symbol = '>>'
            "latex
            if !exists('g:ycm_semantic_triggers')
                let g:ycm_semantic_triggers = {}
            endif
            "let g:ycm_semantic_triggers.tex = g:vimtex#re#youcompleteme

            "自动开启语义补全
            let g:ycm_seed_identifiers_with_syntax = 1
            "在注释中也开启补全
            let g:ycm_complete_in_comments = 1
            let g:ycm_collect_identifiers_from_comments_and_strings = 0
            ""字符串中也开启补全
            let g:ycm_complete_in_strings = 1
            let g:ycm_collect_identifiers_from_tags_files = 1
            "开启基于tag的补全，可以在这之后添加需要的标签路径  
            let g:ycm_collect_identifiers_from_tags_files = 1
            ""开始补全的字符数
            "let g:ycm_min_num_of_chars_for_completion = 2
            "补全后自动关闭预览窗口
            let g:ycm_autoclose_preview_window_after_completion = 1
            ""禁止缓存匹配项,每次都重新生成匹配项
            let g:ycm_cache_omnifunc=0"
            let g:ycm_global_ycm_extra_conf='~/.vim/plugged/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
            let g:ycm_python_binary_path = '/Users/sun/anaconda3/bin/python3'
            "ycm插件 用于声明/定义跳转
            "let g:pydiction_location = '/home/sun/.vim/dict/engspchk.dict'
            nnoremap <leader>gc :YcmCompleter GoToDeclaration<CR>
            " 只能是 #include 或已打开的文件
            nnoremap <leader>gd :YcmCompleter GoToDefinition<CR>
            nnoremap <leader>gD :YcmCompleter GetDoc<CR>
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
            let g:jedi#completions_enabled=1
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
call plug#end()
"================================================================================================================

"================================================================================================================
"my configure
    source ~/.vim/myplugin/configure/vim_unite.vim
    source ~/.vim/myplugin/configure/mystart.vim
    source ~/.vim/myplugin/configure/calendar.vim
    "source ~/.vim/myplugin/configure/myauto.vim
    source ~/.vim/myplugin/configure/myshortcut.vim
    source ~/.vim/myplugin/configure/after.vim
    
"================================================================================================================


