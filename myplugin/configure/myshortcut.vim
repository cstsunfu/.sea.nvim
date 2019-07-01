" File              : myshortcut.vim
" Author            : Sun Fu <cstsunfu@gmail.com>
" Date              : 27.03.2018
" Last Modified Date: 01.07.2019
" Last Modified By  : Sun Fu <cstsunfu@gmail.com>
"=====================================================================================================
"buf_con  B
    " buffer 切换快捷键
    nnoremap <leader>bn :bnext<cr>
    nnoremap <leader>bl :blast<cr>
    nnoremap <leader>bd :Bdelete<cr>
    nnoremap <leader>bp :bprevious<cr>
    nnoremap <leader>bf :bfirst<cr>
"=====================================================================================================

"=====================================================================================================
"ner_con  C
    " <leader>ca，在可选的注释方式之间切换，比如C/C++ 的块注释/* */和行注释//
    " <leader>cc，注释当前行
    " <leader>c，切换注释/非注释状态
    " <leader>cs，以”性感”的方式注释
    " <leader>cA，在当前行尾添加注释符，并进入Insert模式
    " <leader>cu，取消注释
"=====================================================================================================

"=====================================================================================================
"vim-debugger D     codi
"
"ds di draw used
    nmap <M-S-b> <Plug>LLBreakSwitch
    vmap <F2> <Plug>LLStdInSelected
    nnoremap <F4> :LLstdin<CR>
    nnoremap <F5> :LLmode debug<CR>
    nnoremap <S-F5> :LLmode code<CR>
    nnoremap <F8> :LL continue<CR>
    nnoremap <S-F8> :LL process interrupt<CR>
    nnoremap <F9> :LL print <C-R>=expand('<cword>')<CR>
    vnoremap <F9> :<C-U>LL print <C-R>=lldb#util#get_selection()<CR><CR>
    "nnoremap <leader>dp  :VBGstartPDB3 % 
    "nnoremap <leader>db  :VBGstartGDB %<
    "let g:vebugger_leader=','
    "nnoremap <localleader>s :VBGexecute 
    "nnoremap <localleader>p :VBGeval 
    "codi
    "codi deactive
    nnoremap <leader>dcd  :Codi!<CR>
    "python
    nnoremap <leader>dcp  :Codi python<CR>
    "cpp
    nnoremap <leader>dcc  :Codi cpp<CR> 
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

"=====================================================================================================
"equal E
    vmap <leader>er <Plug>AutoCalcReplace 
    vmap <leader>et <Plug>AutoCalcReplaceWithSum
    vmap <leader>ea <Plug>AutoCalcAppend 
    vmap <leader>es <Plug>AutoCalcAppendWithSum 
    vmap <leader>ee <Plug>AutoCalcAppendWithEq
"=====================================================================================================

"=====================================================================================================
"nt_con F
    " 使用 NERDTree 插件查看工程文件。设置快捷键，速记：file list
    nnoremap <leader>ft :NERDTreeToggle<CR>
    nnoremap <leader>fm :set ft=markdown<CR>
    nnoremap <leader>fs :Startify<cr>
    nnoremap <leader>fd :edit ~/.config/nvim/init.vim<cr>
"=====================================================================================================

"=====================================================================================================
"GoTO/ Git G dotoo

    nnoremap <leader>gc :YcmCompleter GoToDeclaration<CR>
    " 只能是 #include 或已打开的文件
    nnoremap <leader>gd :YcmCompleter GoToDefinition<CR>
    nnoremap <leader>gD :YcmCompleter GetDoc<CR>
    nnoremap <leader>gg :GrepperGrep 

    nnoremap <leader>gb :Gblame<CR>
    nnoremap <leader>gC :Gcommit<CR>
    nnoremap <leader>ge :Gedit 
    nnoremap <leader>gf :Gdiff<CR>
    nnoremap <leader>gG :Ggrep 
    nnoremap <leader>gl :Glog<cr> 
    nnoremap <leader>gm :Gmove 
    nnoremap <leader>gr :Gread<CR>
    "nnoremap <leader>gr :Gremove<CR>
    nnoremap <leader>gs :Gstatus<CR>
    nnoremap <leader>gv :Gitv<CR>
    nnoremap <leader>gw :Gwrite<CR>
"=====================================================================================================

"=====================================================================================================
"h history
    "
    nnoremap <leader>ht :UndotreeToggle<cr>
    "history list
    nnoremap <leader>hl q:
"=====================================================================================================

"=====================================================================================================
"i identifier

    "设置显示／隐藏标签列表子窗口的快捷键。速记：identifier list by tag
    nnoremap <leader>ilt :TagbarToggle<CR> 

    fun! Indent()
        %s/^              /\t\t\t\t\t\t\t/g
        %s/^            /\t\t\t\t\t\t/g
        %s/^          /\t\t\t\t\t/g
        %s/^        /\t\t\t\t/g
        %s/^      /\t\t\t/g
        %s/^    /\t\t/g
        %s/^  /\t/g
        %s/\t/    /g
    endf
    nnoremap <silent><leader>id :call Indent()<cr>
"=====================================================================================================

"=====================================================================================================
"l
    nnoremap <leader>ll :Limelight<cr>
    nnoremap <leader>LL :Limelight!<cr>
    vnoremap <leader>ld :Linediff<cr>
"=====================================================================================================

"=====================================================================================================
"m easymotion
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

"m  remote edit
    nnoremap <leader>me :MirrorEdit<cr>
    nnoremap <leader>mc :MirrorConfig<cr>
"=====================================================================================================

"=====================================================================================================
"o org-mode vim-dotoo vimwiki configure at myplugion/vimwiki.vim
    "nnoremap <Leader>oa :Gtd @work (!inbox + !scheduled-<C-R>=strftime("%Y%m%d")<CR>)<CR>
    "nnoremap <Leader>on :GtdNew<CR>
    "nnoremap <Leader>ta gAa
    "nnoremap <Leader>to gAt
    nnoremap <leader>oa :<C-U>call dotoo#agenda#agenda()<CR>
    nnoremap <leader>oc :<C-U>call dotoo#capture#capture()<CR>
    "<Leader>ow -- Open default wiki index file.
    "<Leader>ot -- Open default wiki index file in a new tab.
    "<Leader>os -- Select and open wiki index file.
    "<Leader>od -- Delete wiki file you are in.
    "<Leader>or -- Rename wiki file you are in.
    "<Enter> -- Follow/Create wiki link
    "<Shift-Enter> -- Split and follow/create wiki link
    "<Ctrl-Enter> -- Vertical split and follow/create wiki link
    "<Backspace> -- Go back to parent(previous) wiki link
    "<Tab> -- Find next wiki link
    "<Shift-Tab> -- Find previous wiki link

"=====================================================================================================
"=====================================================================================================
"p
    nnoremap <leader>p "+p
    inoremap <leader>p <esc>"+p
    
"=====================================================================================================

"=====================================================================================================
"q
    nnoremap <leader>qq :qa!<cr>
    nnoremap <leader>qw :qaw<cr>
"=====================================================================================================

"=====================================================================================================
"speeddate_con ,  
    nnoremap <leader>rd :read !date <cr>
    "<C-A>                   Increment by [count] the component under the cursor.
    "<C-X>                   Decrement by [count] the component under the cursor.
    "d<C-A>                  Change the time under the cursor to the current time in UTC.
    "d<C-X>                  Change the time under the cursor to the current local time.
    
"=====================================================================================================
"s ale save ctrlsf, snippet
    nnoremap <leader>se :UltiSnipsEdit<cr>
    "普通模式下，sp前往上一个错误或警告，sn前往下一个错误或警告
    nnoremap <leader>sn :ALENext<cr>
    nnoremap <leader>sp :ALEPrevious<cr>
    "<Leader>s触发/关闭语法检查
    nnoremap <Leader>sc :ALEToggle<CR>
    "<Leader>d查看错误或警告的详细信息
    nnoremap <Leader>sd :ALEDetail<CR>
    "消掉空白
    nnoremap <leader>s<space>  :%s/\s\+$//<cr>
    "定义快捷键保存当前内容
    nnoremap <leader>ss :w<cr>
    nnoremap <leader>sa :wa<cr>
    "ctrlsf
    nnoremap <Leader>sf :CtrlSF<CR>
"=====================================================================================================

"=====================================================================================================
"t table tab
    "Table Mode
    "<leader>tm
    "Tabular_con
    nnoremap <leader>te :Tabularize /=<cr>
    "nnoremap <leader>tv :Tabularize /\|<CR>
    "nnoremap <leader>t: :Tabularize /:<cr>
    "nnoremap <leader>t\ :Tabularize /\,<cr>
    vnoremap <leader>te :Tabularize /=<cr>
    vnoremap <leader>ta :Tabularize /&<cr>
    vnoremap <leader>tv :Tabularize /\|<cr>
    "vnoremap <leader>t: :Tabularize /:\zs<cr>
    "vnoremap <leader>t\ :Tabularize /\,\zs<cr>
    inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a
    function! s:align()
        let p = '^\s*|\s.*\s|\s*$'
        if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
            let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
            let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
            Tabularize/|/l1
            normal! 0
            call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
        endif
    endfunction

    "tags_con"
    "正向遍历同名标签
    nnoremap tn :tnext<cr>
    "反向遍历同名标签
    nnoremap tp :tprevious<cr>
    "在这之前需要先执行 ctrl+] 将同名标签压入栈  分析完之后可以按 ctrl+t 返回
    "ctrl+o 也可返回上次光标停留处 或上一个标签页    ctrl+i可以再回去
    "
    "
    "terminal
    "nnoremap <leader>ts :botright split<cr> :wincmd j<cr> :resize 16<cr> :terminal<cr>a
    nnoremap <leader>ts :botright split<cr> :wincmd j<cr> :terminal<cr>a
    nnoremap <leader>tv :botright vsplit<cr>:wincmd l<cr>:terminal<cr>a
    nnoremap <leader>tr :terminal ranger<cr>
"=====================================================================================================

"=====================================================================================================
"v
    "
    nnoremap <leader>vp :terminal w3m ./a.png<cr>
"=====================================================================================================

"=====================================================================================================
"w
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

"=====================================================================================================
"x 
    nnoremap <leader>x :q<cr>
"=====================================================================================================
"=====================================================================================================
"y tran_con
    "vnoremap <M-c> :<C-u>Ydv<CR>
    nnoremap <leader>yc :<C-u>Ydc<CR>
    "命令行翻译
    noremap <leader>ye :<C-u>Yde<CR>    
    vnoremap <leader>y "+y
"=====================================================================================================

"=====================================================================================================
"F+num
"

    nnoremap <F2> i<esc>:w !python %<cr>
    "nnoremap <F3> i<esc>:w !python3 %<cr>
    nnoremap <F3> :call Run_python()<cr>
    fun! Run_python()
        exec "split"
        exec "wincmd j"
        exec "resize 16"
        exec "terminal python % <in"
    endf
    "nnoremap <F4> :call Run_python()<cr>
    "fun! Run_python()
        "exec "split"
        "exec "wincmd j"
        "exec "resize 16"
        "exec "terminal python %"
    "endf
    noremap <F4> :call CompileRun()<CR>
    func! CompileRun()
        if &filetype=="python"
            exec "split"
            exec "wincmd j"
            exec "resize 16"
            exec "terminal python %"
        elseif &filetype=="c"
            exec "w"
            exec "AsyncRun gcc -Wall -g % -o %<"
            exec "AsyncRun ./%<"
        elseif &filetype=="cpp"
            exec "w"
            exec "AsyncRun g++ -Wall -std=c++11 -g \"%\" -o \"%<\""
            "exec "AsyncRun g++ -Wall -std=c++11 -g \"%\" -o \"%<\""
            "exec "AsyncRun gcc -Wall -std=c11 -g \"%\" -o \"%<\""
            "exec "cw"
            exec "!./%<
        elseif &filetype=="dot"
            exec "w"
            exec "!dot -Tpng -o %<.png % && start %<.png"
        endif
    endfunction

    nnoremap <f6> <esc> :edit %<cr>
    "将外部命令wmctrl控制窗口最大化命令行参数封装成一个vim函数
    fun! ToggleFullscreen()
        call system("vmctrl -ir" . v:windowid . " -b toggle,fullscreen")
    endf

    noremap <F7> :call CompileRun()<CR>
    func! CompileRun()
        if &filetype=="tex"
            exec "w"
            silent exec "!rm %<.pdf"
            exec "!xelatex --shell-escape %<"
            exec "!bibtex %<"
            exec "!xelatex --shell-escape %<"
            exec "!xelatex --shell-escape %<"
            "exec "!dvipdfm %<"
            silent exec "!rm %<.aux %<.dvi %<.toc %<.log %<.snm %<.nav %<.out"
            silent exec "!open %<.pdf"
            silent exec "!rm %<.aux %<.dvi %<.toc %<.log %<.snm %<.nav %<.out"
        elseif &filetype=="python"

            exec "AsyncRun -raw python3 %"
            "exec "AsyncRun set makeprg=python3\ %"
            "exec "set makeprg=python3\%|make"

            "redir => message
            "let filename = expand("%")
            "exec "split python.output"
            "silent exec "read !python3 " filename

            ""redir END
            ""silent exec 
            ""silent put=message
            ""set nomodified
        elseif &filetype=="c"
            exec "w"
            exec "AsyncRun gcc -Wall -g % -o %<"
            exec "AsyncRun ./%<"
        elseif &filetype=="cpp"
            exec "w"
            exec "AsyncRun g++ -Wall -std=c++11 -g \"%\" -o \"%<\""
            "exec "AsyncRun g++ -Wall -std=c++11 -g \"%\" -o \"%<\""
            "exec "AsyncRun gcc -Wall -std=c11 -g \"%\" -o \"%<\""
            "exec "cw"
            exec "!./%< <in >out"
        elseif &filetype=="dot"
            exec "w"
            exec "!dot -Tpng -o %<.png % && start %<.png"
        endif
    endfunction
"=====================================================================================================


"=====================================================================================================
"alt win_con
    "noremap <A-right>   :wincmd l<cr>
    "noremap <A-left>    :wincmd h<cr>
    "noremap <A-down>    :wincmd j<cr>
    "noremap <A-up>      :wincmd k<cr>
    noremap <A-l>   :wincmd l<cr>
    noremap <A-h>    :wincmd h<cr>
    noremap <A-j>    :wincmd j<cr>
    noremap <A-k>      :wincmd k<cr>

    noremap <A-f>    :bnext<cr>
    noremap <A-b>      :bprevious<cr>

    noremap <A-u>          :resize +1<cr>
    noremap <A-d>        :resize -1<cr>
    noremap <A-.>        :vertical resize -1<cr>
    noremap <A-,>       :vertical resize +1<cr>

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
    "inoremap <C-k>  <esc>ld$i
    inoremap <C-a>  <esc>0i
    inoremap <C-b>  <left>
    inoremap <C-f>  <right>
    inoremap <C-e>  <esc>$a
    "inoremap <M-b>  <esc>hbi
    inoremap <M-f>  <esc>lwi

    nnoremap <C-j> 5j
    nnoremap <C-k> 5k
    vnoremap <C-j> 5j
    vnoremap <C-k> 5k
    nnoremap <space><enter> :nohlsearch<cr>
"============================================================================================================================================

"============================================================================================================================================
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
 
"============================================================================================================================================
" Others
    let g:UltiSnipsExpandTrigger="<leader><tab>"
    let g:UltiSnipsJumpForwardTrigger="<leader><tab>"
    let g:UltiSnipsJumpBackwardTrigger="<leader><s-tab>"
    inoremap <leader>; <C-x><C-o>
"============================================================================================================================================
