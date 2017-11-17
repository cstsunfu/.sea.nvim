"=====================================================================================================

"buf_con  B
" buffer 切换快捷键
nnoremap <leader>bn :bnext<cr>
nnoremap <leader>bN :blast<cr>
nnoremap <leader>bd :Bdelete<cr>
nnoremap <leader>bp :bprevious<cr>
nnoremap <leader>bP :bfirst<cr>

"=====================================================================================================
"ner_con  C
" <leader>ca，在可选的注释方式之间切换，比如C/C++ 的块注释/* */和行注释//
" <leader>cc，注释当前行
" <leader>c，切换注释/非注释状态
" <leader>cs，以”性感”的方式注释
" <leader>cA，在当前行尾添加注释符，并进入Insert模式
" <leader>cu，取消注释

"=====================================================================================================
"vim-debugger D
nnoremap <leader>dp  :VBGstartPDB3 % 
nnoremap <leader>db  :VBGstartGDB %<
let g:vebugger_leader=','
nnoremap <localleader>s :VBGexecute 
nnoremap <localleader>p :VBGeval 
"i      |:VBGstepIn|
"o      |:VBGstepOver|
"O      |:VBGstepOut|
"c      |:VBGcontinue|

"b      |:VBGtoggleBreakpointThisLine|
"B      |:VBGclearBreakpoints|

"e      |:VBGevalWordUnderCursor| in normal mode
"|:VBGevalSelectedText| in select mode
"E      Prompt for an argument for |:VBGeval|

"x      |:VBGexecute| current line in normal mode.
"|:VBGexecuteSelectedText| in select mode
"X      Prompt for an argument for |:VBGexecute|

"t      |:VBGtoggleTerminalBuffer|
"r      Select mode only - |:VBGrawWriteSelectedText|
"R Prompt for an argument for |:VBGrawWrite|
"=====================================================================================================
"equal
vmap <leader>er <Plug>AutoCalcReplace 
vmap <leader>et <Plug>AutoCalcReplaceWithSum
vmap <leader>ea <Plug>AutoCalcAppend 
vmap <leader>es <Plug>AutoCalcAppendWithSum 
vmap <leader>ee <Plug>AutoCalcAppendWithEq
"=====================================================================================================
"nt_con F
" 使用 NERDTree 插件查看工程文件。设置快捷键，速记：file list
nnoremap <leader>ft :NERDTreeToggle<CR>

nnoremap <leader>fm :set ft=markdown<CR>
nnoremap <leader>fs :Startify<cr>


"=====================================================================================================
"h history
nnoremap <leader>ht :UndotreeToggle<cr>



"=====================================================================================================
"l
nnoremap <leader>ll :Limelight<cr>
nnoremap <leader>LL :Limelight!<cr>
"=====================================================================================================
nnoremap <leader>p "+p

"=====================================================================================================
nnoremap <leader>qq :q<cr>
nnoremap <leader>qa :qa!<cr>

"=====================================================================================================
"speeddate_con
nnoremap <leader>rd :read !date <cr>
"<C-A>                   Increment by [count] the component under the cursor.
"<C-X>                   Decrement by [count] the component under the cursor.
"d<C-A>                  Change the time under the cursor to the current time in UTC.
"d<C-X>                  Change the time under the cursor to the current local time.
"=====================================================================================================
"ale_con
"普通模式下，sp前往上一个错误或警告，sn前往下一个错误或警告
nnoremap <leader>sp <Plug>(ale_previous_wrap)
nnoremap <leader>sn <Plug>(ale_next_wrap)
"<Leader>s触发/关闭语法检查
nnoremap <Leader>sc :ALEToggle<CR>
"<Leader>d查看错误或警告的详细信息
nnoremap <Leader>sd :ALEDetail<CR>
"消掉空白
nnoremap <leader>s<space>  :%s/\s\+$//<cr>
"定义快捷键保存当前内容
nnoremap <leader>ss :w<cr>
nnoremap <leader>sa :wa<cr>
"=====================================================================================================
"Tabular_con
"nnoremap <leader>te :Tabularize /=<cr>
"nnoremap <leader>tv :Tabularize /\|<CR>
"nnoremap <leader>tm :Tabularize /:<cr>
"nnoremap <leader>tc :Tabularize /\,<cr>
"vnoremap <leader>te :Tabularize /=\zs<cr>
"vnoremap <leader>tv :Tabularize /\|\zs<cr>
"vnoremap <leader>tm :Tabularize /:\zs<cr>
"vnoremap <leader>tc :Tabularize /\,\zs<cr>
"inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a
"function! s:align()
    "let p = '^\s*|\s.*\s|\s*$'
    "if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
        "let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
        "let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
        "Tabularize/|/l1
        "normal! 0
        "call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
    "endif
"endfunction

"tags_con"
"正向遍历同名标签
nnoremap tn :tnext<cr>
"反向遍历同名标签
nnoremap tp :tprevious<cr>
"在这之前需要先执行 ctrl+] 将同名标签压入栈  分析完之后可以按 ctrl+t 返回
"ctrl+o 也可返回上次光标停留处 或上一个标签页    ctrl+i可以再回去
"=====================================================================================================
nnoremap <leader>wm :WMToggle<cr>
nnoremap <leader>ws :split<cr>
nnoremap <leader>wv :vsplit<cr>
nnoremap <leader>wd :q<cr>
nnoremap <leader>ww <c-w><c-w>
nnoremap <leader>wj <c-w>j
nnoremap <leader>wk <c-w>k
nnoremap <leader>wh <c-w>h
nnoremap <leader>wl <c-w>l
nnoremap <leader>wJ <c-w>J
nnoremap <leader>wK <c-w>K
nnoremap <leader>wH <c-w>H
nnoremap <leader>wL <c-w>L
"=====================================================================================================
"tran_con
"vnoremap <M-c> :<C-u>Ydv<CR>
nnoremap <leader>yc :<C-u>Ydc<CR>
"命令行翻译
noremap <leader>ye :<C-u>Yde<CR>    
vnoremap <leader>y "+y
"=====================================================================================================


"F+num
"刷新
nnoremap <f6> <esc> :edit %<cr>
"将外部命令wmctrl控制窗口最大化命令行参数封装成一个vim函数
fun! ToggleFullscreen()
    call system("vmctrl -ir" . v:windowid . " -b toggle,fullscreen")
endf
"if(g:islinux && g:isGUI)
    ""全屏开关快捷键
    "noremap <silent> <F11> :call ToggleFullscreen()<cr>
    ""启动vim自动全屏
    ""autocmd VimEnter * call ToggleFullscreen()
"endif
"if(g:iswindows && g:isGUI)        "需要安装gvimfullscreen.dll
    "noremap <F11> <Esc>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>
"endif

"=====================================================================================================

"win_con
noremap <A-right>   :wincmd l<cr>
noremap <A-left>    :wincmd h<cr>
noremap <A-down>    :wincmd j<cr>
noremap <A-up>      :wincmd k<cr>

"=====================================================================================================
"airline_con
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>- <Plug>AirlineSelectPrevTab
nmap <leader>+ <Plug>AirlineSelectNextTab


"=====================================================================================================

"drawit_con 其中'\'是默认的<leader>键
"\di to start DrawIt and
"\ds to stop  DrawIt.
"|| \a           | draw arrow from corners of visual-block selected region   ||  |drawit-a|
"|| \b           | draw box on visual-block selected region                  ||  |drawit-b|
"|| \c           | the canvas routine (will query user, see above)           ||  |drawit-c|
"|| \e           | draw an ellipse on visual-block selected region           ||  |drawit-e|
"|| \f           | flood figure with a character (you will be prompted)      ||  |drawit-f|
"|| \l           | draw line from corners of visual-block selected region    ||  |drawit-l|
"|| \s           | spacer: appends spaces up to the textwidth (default: 78)  ||  |drawit-s|

"=====================================================================================================
"emacs
inoremap <C-k>  <esc>ld$i
inoremap <C-a>  <esc>0i
inoremap <C-b>  <left>
inoremap <C-f>  <right>
inoremap <C-e>  <esc>$a
inoremap <M-b>  <esc>bi
inoremap <M-f>  <esc>a

noremap <C-j> 5j
noremap <C-k> 5k
nnoremap <space><enter> :nohlsearch<cr>
