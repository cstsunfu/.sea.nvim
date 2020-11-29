if exists('g:load_fzf') && g:load_fzf
    "{{{vim-mrufiles
    let g:mrufiles_max_entries = 1000
    "}}}
    "{{{fzf
    autocmd! FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
    let g:fzf_colors =
          \ {'fg':      ['fg', 'Normal'],
          \ 'bg':      ['bg', 'Normal'],
          \ 'hl':      ['fg', 'Comment'],
          \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
          \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
          \ 'hl+':     ['fg', 'Statement'],
          \ 'info':    ['fg', 'PreProc'],
          \ 'border':  ['fg', 'Ignore'],
          \ 'prompt':  ['fg', 'Conditional'],
          \ 'pointer': ['fg', 'Exception'],
          \ 'marker':  ['fg', 'Keyword'],
          \ 'spinner': ['fg', 'Label'],
          \ 'header':  ['fg', 'Comment'] }
    " popup&&float window
    " border [string default 'rounded']: Border style ('rounded' | 'sharp' | 'horizontal')
    "
    hi FZFBorder ctermfg=Black guifg=Black
    "exec 'hi FZFNone ctermfg='.synIDattr(hlID('Normal'),'bg').' guifg'.synIDattr(hlID('Normal'),'bg')
    "let g:fzf_layout = { 'window': { 'width': 0.96, 'height': 0.76, 'yoffset': 1, 'border': 'rounded' , 'highlight':'FZFBorder'} }
    "
    fu s:snr() abort
        return matchstr(expand('<sfile>'), '.*\zs<SNR>\d\+_')
    endfu
    let s:snr = get(s:, 'snr', s:snr())
    "let g:fzf_layout = {'window': 'call '..s:snr..'fzf_window(0.96, 0.76, "Comment")'}
    let g:fzf_layout = {'window': 'call '..s:snr..'fzf_window(0.96, 0.76, "Comment")'}
    fu s:create_float(hl, opts) abort
        let buf = nvim_create_buf(v:false, v:true)
        let opts = extend({'relative': 'editor', 'style': 'minimal'}, a:opts)
        let win = nvim_open_win(buf, v:true, opts)
        call setwinvar(win, '&winhighlight', 'NormalFloat:'..a:hl)
        return buf
    endfu
    fu s:fzf_window(width, height, border_highlight) abort
        let width = float2nr(&columns * a:width)
        let height = float2nr(&lines * a:height)
        let row = float2nr((&lines - height) / 2)
        let col = float2nr((&columns - width) / 2)
        let top = '┌' . 'sunfu.vim'.repeat('─', width - 11) . '┐'
        let mid = '│' . repeat(' ', width - 2) . '│'
        let bot = '└' . repeat('─', width - 2) . '┘'
        let border = [top] + repeat([mid], height - 2) + [bot]
        if has('nvim')
            let frame = s:create_float(a:border_highlight, {
                \ 'row': row,
                \ 'col': col,
                \ 'width': width,
                \ 'height': height,
                \ })
            call nvim_buf_set_lines(frame, 0, -1, v:true, border)
            "call s:create_float('Normal', {
            call s:create_float('Ignore', {
                \ 'row': row + 1,
                \ 'col': col + 2,
                \ 'width': width - 4,
                \ 'height': height - 2,
                \ })
            exe 'au BufWipeout <buffer> bw '..frame
        else
            let frame = s:create_popup_window(a:border_highlight, {
                \ 'line': row,
                \ 'col': col,
                \ 'width': width,
                \ 'height': height,
                \ 'is_frame': 1,
                \ })
            call setbufline(frame, 1, border)
            call s:create_popup_window('Normal', {
                \ 'line': row + 1,
                \ 'col': col + 2,
                \ 'width': width - 4,
                \ 'height': height - 2,
                \ })
        endif
    endfu
    fu s:create_popup_window(hl, opts) abort
        if has_key(a:opts, 'is_frame')
            let id = popup_create('', #{
                \ line: a:opts.line,
                \ col: a:opts.col,
                \ minwidth: a:opts.width,
                \ minheight: a:opts.height,
                \ zindex: 50,
                \ })
            call setwinvar(id, '&wincolor', a:hl)
            exe 'au BufWipeout * ++once call popup_close('..id..')'
            return winbufnr(id)
        else
            let buf = term_start(&shell, #{hidden: 1})
            call popup_create(buf, #{
                \ line: a:opts.line,
                \ col: a:opts.col,
                \ minwidth: a:opts.width,
                \ minheight: a:opts.height,
                \ zindex: 51,
                \ })
            exe 'au BufWipeout * ++once bw! '..buf
        endif
    endfu
    "}}}
endif

if exists('g:load_jupyter_vim') && g:load_jupyter_vim
    "{{{vim-jupyter
    nnoremap <C-s> :JupyterSendCount<CR>
    vnoremap <localleader>e :JupyterRunVisual<CR>
    nnoremap <leader>jr :!jupyter qtconsole&<cr>
    nnoremap <leader>jc :JupyterConnect<cr>
    "}}}
endif

if exists('g:load_ycm') && g:load_ycm
    "{{{YouCompleteMe
    "===================================================================================================================
    "complete
    "vim命令行模式智能补全
    "YouCompleteMe
    let g:ycm_filetype_blacklist = {
        \ 'tagbar': 1,
        \ 'qf': 1,
        \ 'notes': 1,
        \ 'unite': 1,
        \ 'text': 1,
        \ 'pandoc': 1,
        \ 'infolog': 1,
        \ 'mail': 1,
        \}
    let g:ycm_error_symbol = '*'
    "latex
    if !exists('g:ycm_semantic_triggers')
        let g:ycm_semantic_triggers = {}
    endif

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
    "补全后自动关闭预览窗口
    let g:ycm_autoclose_preview_window_after_completion = 1


    ""禁止缓存匹配项,每次都重新生成匹配项
    let g:ycm_cache_omnifunc=0"
    let g:ycm_global_ycm_extra_conf=$HOME.'/.vim/.ycm_extra_conf.py'
    " 补全功能在注释中同样有效
    let g:ycm_complete_in_comments=1
    " 允许 vim 加载 .ycm_extra_conf.py 文件，不再提示
    let g:ycm_confirm_extra_conf=0
    " 开启 YCM 标签补全引擎
    let g:ycm_collect_identifiers_from_tags_files=1
    " 引入 C++ 标准库tags
    "set tags+=/usr/include/c++/6.4.1/stdcpp.tags
    " YCM 集成 OmniCppComplete 补全引擎，设置其快捷键
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
    let g:indexer_ctagsCommandLineOptions="--c++-kinds=+p+l+x+c+d+e+f+g+m+n+s+t+u+v --fields=+iaSl --extra=+q"
    "}}}
endif

if exists('g:load_vista') && g:load_vista
    "{{{vista
    let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
    " Executive used when opening vista sidebar without specifying it.
    " See all the avaliable executives via `:echo g:vista#executives`.
    let g:vista_default_executive = 'ctags'
    
    " Set the executive for some filetypes explicitly. Use the explicit executive
    " instead of the default one for these filetypes when using `:Vista` without
    " specifying the executive.
    let g:vista_executive_for = {
      \ 'cpp': 'vim_lsp',
      \ 'php': 'vim_lsp',
      \ 'markdown': 'toc',
      \ 'vimwiki': 'markdown',
      \ }
    " Declare the command including the executable and options used to generate ctags output
    " for some certain filetypes.The file path will be appened to your custom command.
    " For example:
    let g:vista_ctags_cmd = {
          \ 'haskell': 'hasktags -x -o - -c',
          \ }
    
     "To enable fzf's preview window set g:vista_fzf_preview.
     "The elements of g:vista_fzf_preview will be passed as arguments to fzf#vim#with_preview()
     "For example:
    let g:vista_fzf_preview = ['right:50%']
    let g:vista_fzf_preview = ['left:50%']
     "Ensure you have installed some decent font to show these pretty symbols, then you can enable icon for the kind.
    let g:vista#renderer#enable_icon = 1
    let g:vista_stay_on_open=0
    
    " The default icons can't be suitable for all the filetypes, you can extend it as you wish.
    let g:vista#renderer#icons = {
    \   "function": "\uf794",
    \   "functions": "\uf794",
    \   "variable": "\uf005",
    \   "variables": "\uf005",
    \   "maps": "\uf279",
    \   "members": "\ufa85",
    \   "classes": "\ue61e",
    \   "autocommand groups": "\uf7c2",
    \  }
    let g:vista_sidebar_width=winwidth('%')/11*2
    let g:vista_sidebar_position="vertical topleft"
    "}}}
endif

if exists('g:load_ale') && g:load_ale
    "{{{ale
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
    let g:ale_python_flake8_executable = 'python3'   " or 'python' for Python 2
    let g:ale_python_mypy_executable = 'python3'
    let g:ale_python_flake8_options = '-m flake8'
    "let g:ale_python_flake8_options = '--max-line-length 12'
    let g:ale_linters = {
          \   'python': ['flake8'],
          \   'ruby': ['standardrb', 'rubocop'],
          \   'javascript': ['eslint'],
          \}
    "let g:ale_fix_on_save = 1
    let g:ale_fixers = {
    \  'python': [
    \    'remove_trailing_lines',
    \    'isort',
    \    'ale#fixers#generic_python#BreakUpLongLines',
    \    'yapf'
    \   ]
    \}
    "}}}
endif

if exists('g:load_defx') && g:load_defx
    "{{{defx
    let g:defx_icons_enable_syntax_highlight = 1
    let g:defx_icons_column_length = 2
    "let g:defx_icons_directory_icon = ''
    let g:defx_icons_directory_icon = "✚"
    let g:defx_icons_mark_icon = '*'
    "let g:defx_icons_parent_icon = ''
    let g:defx_icons_parent_icon = ""
    let g:defx_icons_default_icon = ''
    let g:defx_icons_directory_symlink_icon = ''
    " Options below are applicable only when using "tree" feature
    let g:defx_icons_root_opened_tree_icon = ''
    let g:defx_icons_nested_opened_tree_icon = ''
    let g:defx_icons_nested_closed_tree_icon = ''
    "}}}
endif

if exists('g:load_nerd_tree') && g:load_nerd_tree
    "{{{nerd_tree
    let g:NERDTreeIndicatorMapCustom = {
        \ "Modified"  : "✹",
        \ "Staged"    : "✚",
        \ "Untracked" : "✭",
        \ "Renamed"   : "➜",
        \ "Unmerged"  : "═",
        \ "Deleted"   : "✖",
        \ "Dirty"     : "✗",
        \ "Clean"     : "✔︎",
        \ 'Ignored'   : '☒',
        \ "Unknown"   : "?"
        \ }
    " 设置NERDTree子窗口宽度
    let NERDTreeWinSize=winwidth('%')/11*2
    " 设置NERDTree子窗口位置
    let NERDTreeWinPos="right"
    " 显示隐藏文件
    let NERDTreeShowHidden=1
    " NERDTree 子窗口中不显示冗余帮助信息
    let NERDTreeMinimalUI=1
    " 删除文件时自动删除文件对应 buffer
    let NERDTreeAutoDeleteBuffer=1
    let NERDTreeIgnore=['\.o$', '\.hi', '\.docs$', '\.doc$', '\.pdf$', '\~$']
    "}}}
endif

if exists('g:load_easy_change') && g:load_easy_change
    "{{{dragvisuals
    vmap  <expr>  <LEFT>   DVB_Drag('left')
    vmap  <expr>  <RIGHT>  DVB_Drag('right')
    vmap  <expr>  <DOWN>   DVB_Drag('down')
    vmap  <expr>  <UP>     DVB_Drag('up')
    vmap  <expr>  D        DVB_Duplicate()
    "}}}
endif
if exists('g:load_org_my_life') && g:load_org_my_life
    "{{{ beancount
    let b:beancount_root = '~/bean/accounts.bean'
    "}}}
    "{{{ vimwiki
    let g:vimwiki_list = [{'path': $HOME.'/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}] 
    "let g:vimwiki_list = [{'path': '~/vimwiki/', 'ext': '.md'}] 
    let wiki_1 = {}
    let wiki_1.path = $HOME.'/vimwiki/'
    let wiki_1.auto_tags = 1
    let wiki_1.syntax='markdown'
    let wiki_1.ext='.md'
    let wiki_1.html_template = $HOME.'/public_html/template.tpl'
    let wiki_1.nested_syntaxes = {'python': 'python', 'c++': 'cpp'}
    
    let wiki_2 = {}
    let wiki_2.path = $HOME.'/project_docs/'
    let wiki_2.index = 'main'
    let g:vimwiki_list = [wiki_1, wiki_2]
    "}}}
    "{{{vim-dotoo
    let g:dotoo#agenda#files = ['~/Documents/dotoo-files/*.dotoo']
    let g:dotoo#capture#refile = expand( '~/Documents/dotoo-files/refile.dotoo')
    let g:dotoo#capture#templates = {
          \ 't': {
          \   'description': 'Todo',
          \   'lines': [
          \     '* TODO %?',
          \     'DEADLINE: [%(strftime(g:dotoo#time#datetime_format))]'
          \   ],
          \  'target': $HOME.'/Documents/dotoo-files/refile.dotoo'
          \ },
          \ 'n': {
          \   'description': 'Note',
          \   'lines': ['* %? :NOTE:'],
          \ },
          \ 'm': {
          \   'description': 'Meeting',
          \   'lines': ['* MEETING with %? :MEETING:'],
          \ },
          \ 'p': {
          \   'description': 'Phone call',
          \   'lines': ['* PHONE %? :PHONE:'],
          \ },
          \ 'h': {
          \   'description': 'Habit',
          \   'lines': [
          \     '* NEXT %?',
          \     'SCHEDULED: [%(strftime(g:dotoo#time#date_day_format)) +1m]',
          \     ':PROPERTIES:',
          \     ':STYLE: habit',
          \     ':REPEAT_TO_STATE: NEXT',
          \     ':END:'
          \   ]
          \ },
          \ 'r': {
          \   'description': 'Reading',
          \   'lines': [
          \     '* READING %?   :BOOK:',
          \     'SCHEDULED: [%(strftime(g:dotoo#time#date_day_format)) +1m]',
          \     ':PROPERTIES:',
          \     ':END:'
          \   ]
          \ }
          \}
    let g:dotoo_todo_keyword_faces = [
                \ ['TODO', [':foreground 160', ':weight bold']],
                \ ['NEXT', [':foreground 27', ':weight bold']],
                \ ['DONE', [':foreground 22', ':weight bold']],
                \ ['WAITING', [':foreground 202', ':weight bold']],
                \ ['HOLD', [':foreground 53', ':weight bold']],
                \ ['CANCELLED', [':foreground 22', ':weight bold']],
                \ ['MEETING', [':foreground 22', ':weight bold']],
                \ ['READING', [':foreground 22', ':weight bold']],
                \ ['PHONE', [':foreground 22', ':weight bold']]
                \ ]
    let g:dotoo#parser#todo_keywords = [
                \ 'TODO',
                \ 'NEXT',
                \ 'WAITING',
                \ 'HOLD',
                \ 'PHONE',
                \ 'MEETING',
                \ 'READING',
                \ '|',
                \ 'CANCELLED',
                \ 'DONE']
    "}}}
endif

if exists('g:load_translate_me') && g:load_translate_me
    "{{{translate_me
    let g:vtm_default_engines = ['youdao', 'google']
    "}}}
endif
if exists('g:load_beauty_vim') && g:load_beauty_vim
    "{{{ vim-devicons
    let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {} " needed
    let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['bean']  = ''
    "}}}
    "{{{startify
    let g:startify_files_number = 10
    let g:startify_enable_unsafe = 0
    function! StartifyEntryFormat()
        return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
    endfunction


    let g:startify_padding_left = float2nr((&columns / 2) - (66 / 2) - 1)
    let s:startify_custom_header_origin = [
                \ '  ____                _____      _      __     _____ __  __   ',
                \ ' / ___| _   _ ____   |  ___|   _( )___  \ \   / /_ _|  \/  |  ',
                \ ' \___ \| | | |  _ \  | |_ | | | |// __|  \ \ / / | || |\/| |  ',
                \ '  ___) | |_| | | | | |  _|| |_| | \__ \   \ V /  | || |  | |  ',
                \ ' |____/ \__,_|_| |_| |_|   \__,_| |___/    \_/  |___|_|  |_|  ',
                \ '                                                              ',
                \ '                                                              ',
                \ '                                                              ',
                \ '                               Email    : cstsunfu@gmail.com  ',
                \ '                               Bilibili : 无用的技术          ',
                \ '                               Youtube  : 无用的技术          ',
                \ '                                                              ',
                \ ]
    function s:center(lines) abort
        let longest_line = max(map(copy(a:lines), 'strwidth(v:val)'))
        return map(copy(a:lines),
                    \ 'repeat(" ", (&columns / 2) - (longest_line / 2) - 1) . v:val')
    endfunction
    let g:startify_custom_header = s:center(s:startify_custom_header_origin)

    "let g:startify_custom_header =
          "\ 'startify#center(startify#fortune#cowsay())'
    "}}}
    "{{{python-syntax
    let g:python_highlight_all = 1
    "}}}
endif
if exists('g:load_format') && g:load_format
    "{{{neoformat
    let g:neoformat_enabled_python = ['yapf', 'autopep8', 'docformatter']
    "}}}
endif

if exists('g:load_vimspector') && g:load_vimspector
    "{{{vimspector
    let g:vimspector_enable_mappings = 'HUMAN'
    "}}}
endif
if exists('g:load_lang_latex') && g:load_lang_latex
    "{{{vim-latex-live-preview
    "let g:livepreview_previewer = 'evince'
    let &rtp  = g:root_path.'plugged/vimtex,' . &rtp
    let &rtp .= g:root_path.'plugged/vimtex/after'
    let g:livepreview_previewer = 'open -a skim'
    "let g:livepreview_engine = 'xelatex' . '--shell-escape'
    "let g:livepreview_engine = 'pdflatex'
    let g:livepreview_engine = 'xelatex'
    set updatetime=1000
    "}}}
    "{{{vimtex
    let g:tex_flavor                          = 'latex'
    let g:vimtex_quickfix_mode             = 2
    let g:vimtex_latexmk_options              = '-xelatex -verbose -file-line-error -synctex=1 -shell-escape -interaction=nonstopmode' 
    let g:vimtex_view_general_viewer          = 'open'
    "let g:vimtex_view_general_options         = '-reuse-instance -inverse-search "\"' . $VIMRUNTIME . '\gvim.exe\" -n --remote-silent +\%l \"\%f\"" -forward-search @tex @line @pdf'
    let g:vimtex_compiler_method = 'latexmk'
    "let g:vimtex_view_general_options_latexmk = '-reuse-instance'
    let g:vimtex_compiler_progname = 'nvr'
    "}}}
endif

if exists('g:load_asyncrun') && g:load_asyncrun
    "{{{asyncrun
    " 自动打开 quickfix window ，高度为 6
    let g:asyncrun_open = 6
    
    " 任务结束时候响铃提醒
    let g:asyncrun_bell = 1
    let $PYTHONUNBUFFERED=1
    
    "" 设置 F10 打开/关闭 Quickfix 窗口
    "nnoremap <F10> :call asyncrun#quickfix_toggle(6)<cr>
    ""}}}
endif

if exists('g:load_enhance_markdown') && g:load_enhance_markdown
    "table-mode---------{{{
    let g:table_mode_corner='|'
    "}}}
    "{{{markdown_preview
    let g:mkdp_auto_start = 0
    let g:mkdp_auto_close = 1
    let g:mkdp_preview_options = {
        \ 'mkit': {},
        \ 'katex': {},
        \ 'uml': {},
        \ 'maid': {},
        \ 'disable_sync_scroll': 0,
        \ 'sync_scroll_type': 'middle',
        \ 'hide_yaml_meta': 1
        \ }
    "let g:mkdp_markdown_css = '~/.vim/css/main.css'
    "let g:mkdp_highlight_css = '~/.vim/css/main.css'
    "}}}
endif

if exists('g:load_default_plugin') && g:load_default_plugin
    "{{{ indentline
    " 与latex有冲突，该插件会使tex文件的数学符号直接显示出来
    let g:indentLine_fileTypeExclude = ['tex']
    "}}}
    "{{{ultisnips
    " UltiSnips 的 tab 键与 YCM 冲突，重新设定
    "let g:UltiSnipsExpandTrigger="<leader><tab>"
    "let g:UltiSnipsJumpForwardTrigger="<leader><tab>"
    "let g:UltiSnipsJumpBackwardTrigger="<leader><s-tab>"
    let g:UltiSnipsEditSplit='vertical'
    let g:snips_author= 'Sun Fu'
    let g:snips_email= 'cstsunfu@gmail.com'
    let g:snips_github= 'https://github.com/cstsunfu'
    let g:snips_wechat= 'cstsunfu'
    let g:UltiSnipsSnippetsDir = g:root_path.'plugged/vim-snippets/UltiSnips'
    "}}}
    "{{{vim-polyglot 多语言预发支持
    let g:polyglot_disabled = ['latex']
    "}}}
    "{{{tagbar
    let g:tagbar_position='left'
    let g:tagbar_width = max([25, winwidth(0)/9*2])
    "}}}
    "{{{Quick-scope
    " Trigger a highlight in the appropriate direction when pressing these keys:
    let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
    "}}}
endif


