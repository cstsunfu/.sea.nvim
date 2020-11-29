" File              : myshortcut.vim
" Author            : Sun Fu <cstsunfu@gmail.com>
" Date              : 06.08.2019
" Last Modified Date: 06.08.2019
" Last Modified By  : Sun Fu <cstsunfu@gmail.com>
"buf_con  B
"{{{
" buffer 切换快捷键
nnoremap <leader>bn :bnext<cr>
nnoremap <leader>bl :blast<cr>
nnoremap <leader>bd :Bdelete<cr>

fun! s:DeleteAllBuffersInWindow()
    let s:curWinNr = winnr()
    if winbufnr(s:curWinNr)==1
        ret
    endif
    let s:curBufNr = bufnr("%")
    exe "bn"
    let s:nextBufNr = bufnr("%")
    while s:nextBufNr != s:curBufNr
        exe "bn"
        exe "bdel ".s:nextBufNr
        let s:nextBufNr = bufnr("%")
    endw
endf
nnoremap <silent><leader>fo :call configure#dfx#defx_open({ 'split': v:true, 'find_current_file': v:true })<CR>

"nnoremap <leader>bD 
nnoremap <leader>bD :call <SID>DeleteAllBuffersInWindow()<cr>
nnoremap <leader>bp :bprevious<cr>
nnoremap <leader>bf :bfirst<cr>
"}}}
"=====================================================================================================
"ner_con  C
"{{{
" <leader>ca，在可选的注释方式之间切换，比如C/C++ 的块注释/* */和行注释//
" <leader>cc，注释当前行
" <leader>c，切换注释/非注释状态
" <leader>cs，以”性感”的方式注释
" <leader>cA，在当前行尾添加注释符，并进入Insert模式
" <leader>cu，取消注释
"}}}
"=====================================================================================================
"vim-debugger D     codi
"ds di draw used
"{{{

"nnoremap<F5>    <Plug>VimspectorContinue
"nnoremap<S-F5>    <Plug>VimspectorStop
"nnoremap<C-S-F5>    <Plug>VimspectorRestart
"nnoremap<F6>    <Plug>VimspectorPause
"nnoremap<F9>    <Plug>VimspectorToggleBreakpoint
"nnoremap<F7>    <Plug>VimspectorToggleConditionalBreakpoint
"nnoremap<S-F9>    <Plug>VimspectorAddFunctionBreakpoint
"nnoremap<F10>    <Plug>VimspectorStepOver
"nnoremap<F11>    <Plug>VimspectorStepInto
"nnoremap<S-F11>    <Plug>VimspectorStepOut
nnoremap<leader>de :VimspectorEval 
nnoremap<leader>dw :VimspectorWatch 
"dr for directory di&ds for drawit
nnoremap<leader>dc :VimspectorReset 
"codi
"codi deactive
nnoremap <leader>dcd  :Codi!<CR>
"python
nnoremap <leader>dcp  :Codi python<CR>
"cpp
nnoremap <leader>dcc  :Codi cpp<CR> 
"nnoremap <silent><Leader>df :call <sid>defx_open({ 'split': v:true })<CR>
"nnoremap <silent><Leader>dr :call <sid>defx_open({ 'split': v:true, 'find_current_file': v:true })<CR>
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
"}}}
"=====================================================================================================
"equal E
"{{{
vmap <leader>er <Plug>AutoCalcReplace 
vmap <leader>et <Plug>AutoCalcReplaceWithSum
vmap <leader>ea <Plug>AutoCalcAppend 
vmap <leader>es <Plug>AutoCalcAppendWithSum 
vmap <leader>ee <Plug>AutoCalcAppendWithEq
function! InlineEval()
python3 << EOF
import math
log = math.log
exp = math.exp
pi = math.pi
cos = math.cos
sin = math.sin
tan = math.tan
asin = math.asin
acos = math.acos
atan = math.atan
pi = math.pi
sqrt = math.sqrt
start_row, start_col = list(vim.current.buffer.mark('<'))
end_row, end_col = list(vim.current.buffer.mark('>'))
cur_line = list(vim.current.buffer[start_row-1])
will_eval = ''.join(cur_line[start_col:end_col+1])
cur_line[start_col:end_col+1] = str(eval(will_eval))
vim.current.buffer[start_row-1] = ''.join(cur_line)
EOF
endfunction
vmap <leader>el :call InlineEval()<cr>
"}}}
"=====================================================================================================
"nt_con F fzf, preview
"{{{
" 使用 NERDTree 插件查看工程文件。设置快捷键，弃用
nnoremap <leader>ft :NERDTreeToggle<CR>
nnoremap <leader>fm :set ft=markdown<CR>
nnoremap <leader>fs :Startify<cr>
nnoremap <leader>fd :edit $HOME/.config/nvim/init.vim<cr>
nnoremap <leader>fe :MarkdownPreview<cr>


"fzf
nnoremap <leader>fC :Colors<cr>
nnoremap <leader>ff :Files<cr>
nnoremap <leader>fh :History<cr>
"function! s:wikipageFzf()
    "let l:paths = map(copy(g:vimwiki_wikilocal_vars), {i, v -> v['path']})
    "let l:paths = uniq(sort(l:paths))
    "let l:wikiFiles = globpath(join(l:paths, ','), '**/*.md', 0, 1)
    "call fzf#run(fzf#wrap({
                "\ 'source': l:wikiFiles,
                "\ 'down': '40%',
                "\ 'options': fzf#vim#with_preview('right:50%').options,
                "\ }, 0))
                ""\ 'options': fzf#vim#with_preview('down:45%, ').options,
                ""\ 'options': fzf#vim#with_preview('down:45%').options,
"endfunction
command! -bang JobFiles call fzf#vim#files('~/job', <bang>0)
command! -bang WikiFiles call fzf#vim#files('~/vimwiki', <bang>0)

nnoremap <leader>fw :WikiFiles<Cr>
nnoremap <leader>fj :JobFiles<Cr>
nnoremap <leader>fr :FzfMruFiles<Cr>
nnoremap <leader>fn :Maps<Cr>
nnoremap <leader>fq :Rg<Cr>
nnoremap <leader>fl :Lines<Cr>
nnoremap <leader>f<tab> :Snippets<Cr>
nnoremap <leader>fc :Commits<Cr>
nnoremap <leader>fg :Rg<Cr>
"}}}
"=====================================================================================================
"GoTO/ Git G dotoo
"{{{
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
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gv :Gitv<CR>
nnoremap <leader>gw :Gwrite<CR>
"}}}
"
"=====================================================================================================
"h history
"{{{
"
nnoremap <leader>ht :UndotreeToggle<cr>
"history list
nnoremap <leader>hl q:
"}}}
"=====================================================================================================
"i identifier
"{{{
fun! Indent()
    %s/^              /\t\t\t\t\t\t\t/g
    %s/^            /\t\t\t\t\t\t/g
    %s/^          /\t\t\t\t\t/g
    %s/^        /\t\t\t\t/g
    %s/^      /\t\t\t/g
    %s/^    /\t\t/g
    %s/^  /\t/g
endf
nnoremap <silent><leader>id :call Indent()<cr>
fun! Indent()
    %s/^\t\t\t\t\t\t\t/              /g
    %s/^\t\t\t\t\t\t/            /g
    %s/^\t\t\t\t\t/          /g
    %s/^\t\t\t\t/        /g
    %s/^\t\t\t/      /g
    %s/^\t\t/    /g
    %s/^\t/  /g
endf
"}}}
"=====================================================================================================
"l
"{{{
nnoremap <leader>ll :Limelight<cr>
nnoremap <leader>LL :Limelight!<cr>
vnoremap <leader>ld :Linediff<cr>
"}}}
"=====================================================================================================
"m easymotion
"{{{
    " <Leader>f{char} to move to {char}
    map  <Leader>mf <Plug>(easymotion-bd-f)
    nmap <Leader>mf <Plug>(easymotion-overwin-f)
    " s{char}{char} to move to {char}{char}
    " Move to line
    map <Leader>ml <Plug>(easymotion-bd-jk)
    nmap <Leader>ml <Plug>(easymotion-overwin-line)
    " Move to word
    map  <Leader>mw <Plug>(easymotion-bd-w)
    nmap <Leader>mw <Plug>(easymotion-overwin-w)

"m  remote edit
    nnoremap <leader>me :MirrorEdit<cr>
    nnoremap <leader>mc :MirrorConfig<cr>
"}}}
"=====================================================================================================
"o org-mode vim-dotoo vimwiki configure at myplugion/vimwiki.vim
"{{{
"nnoremap <Leader>oa :Gtd @work (!inbox + !scheduled-<C-R>=strftime("%Y%m%d")<CR>)<CR>
"nnoremap <Leader>on :GtdNew<CR>
nnoremap <leader>oa :<C-U>call dotoo#agenda#agenda()<CR>
nnoremap <leader>oc :<C-U>call dotoo#capture#capture()<CR>

"nnoremap <buffer> <leader>ox <Plug>VimwikiToggleListItem

nmap <Leader>ol <Plug>VimwikiToggleListItem
vmap <Leader>ol <Plug>VimwikiToggleListItem
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

"}}}
"=====================================================================================================
"p
"{{{
nnoremap <leader>p "+p
inoremap <leader>p <esc>"+p
"}}}
"=====================================================================================================
"q
"{{{
"quick run, quick build
    nnoremap <leader>qq :qa<cr>
    nnoremap <leader>qw :qaw<cr>
    "quick run & build
    noremap <leader>qr :AsyncTask run<cr>
    noremap <leader>qb :AsyncTask build<cr>
"}}}
"=====================================================================================================
"r
"speeddate_con ,  
"{{{
nnoremap <leader>rd :read !date <cr>
"<C-A>                   Increment by [count] the component under the cursor.
"<C-X>                   Decrement by [count] the component under the cursor.
"d<C-A>                  Change the time under the cursor to the current time in UTC.
"d<C-X>                  Change the time under the cursor to the current local time.
"}}}
"=====================================================================================================
"s ale save ctrlsf, snippet
"{{{
nnoremap <leader>se :UltiSnipsEdit!<cr>
"普通模式下，sp前往上一个错误或警告，sn前往下一个错误或警告
nnoremap <leader>sn :ALENext<cr>
nnoremap <leader>sp :ALEPrevious<cr>
"<Leader>s触发/关闭语法检查
nnoremap <Leader>sc :ALEToggle<CR>
"<Leader>d查看错误或警告的详细信息
nnoremap <Leader>sd :ALEDetail<CR>
"消掉空白
nnoremap <leader>s<space>  :%s/\s\+$//<cr>
"nnoremap <F5> :source $HOME/.vim/configure/default.vim<CR>
"定义快捷键保存当前内容
nnoremap <leader>ss :w<cr>
nnoremap <leader>sa :wa<cr>
"ctrlsf
nnoremap <leader>sf :CtrlSF<CR>

nnoremap <leader>sp :setlocal spell! spelllang=en_us,cjk<CR>
"}}}
"=====================================================================================================
"t table tab
"{{{
"Table Mode
"<leader>tm
"Tabular_con
nnoremap <leader>te :Tabularize /=<cr>
"nnoremap <leader>tfe defined by table mode table formula eval
"nnoremap <leader>tfa defined by table mode table formula add
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
nmap <silent> <Leader>tw <Plug>TranslateW
vmap <silent> <Leader>tw <Plug>TranslateWV
"" <Leader>t 翻译光标下的文本，在命令行回显
"nmap <silent> <Leader>tt <Plug>Translate
"vmap <silent> <Leader>tt <Plug>TranslateV
" 定义于 vista defx配置
nnoremap <leader>tl :TagbarToggle<CR>
autocmd FileType markdown,vimwiki nnoremap <buffer> <leader>tl :Vista!!<CR>
"nnoremap <leader>ta :call <sid>defx_open({ 'split': v:true })<cr> :Vista!!<CR>
"}}}
"=====================================================================================================
"v
"{{{
nnoremap <leader>vp :terminal w3m ./a.png<cr>
"}}}
"=====================================================================================================
"w
"{{{
"nnoremap <leader>wm :WMToggle<cr>
nmap <leader>wm <Plug>(zoom-toggle)
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
"}}}
"=====================================================================================================
"x 
"{{{
nnoremap <leader>x :q<cr>
"}}}
"=====================================================================================================
"y tran_con
"{{{
vnoremap <leader>y "+y
"}}}
"=====================================================================================================
"alt win_con
"{{{
if has('mac')
    "Alt+lhjk
    noremap ¬   :wincmd l<cr>
    noremap ˙   :wincmd h<cr>
    noremap ∆   :wincmd j<cr>
    noremap ˚   :wincmd k<cr>
    "Alt+fb
    noremap ƒ   :bnext<cr>
    noremap ∫   :bprevious<cr>
    "Alt+wsad
    noremap ∑   :resize +1<cr>
    noremap ß   :resize -1<cr>
    noremap å   :vertical resize -1<cr>
    noremap ∂   :vertical resize +1<cr>
else
    noremap <A-l>   :wincmd l<cr>
    noremap <A-h>    :wincmd h<cr>
    noremap <A-j>    :wincmd j<cr>
    noremap <A-k>      :wincmd k<cr>

    noremap <A-f>    :bnext<cr>
    noremap <A-b>      :bprevious<cr>

    noremap <A-w>          :resize +1<cr>
    noremap <A-s>        :resize -1<cr>
    noremap <A-a>        :vertical resize -1<cr>
    noremap <A-d>       :vertical resize +1<cr>
endif

"}}}
"=====================================================================================================
"airline_con
"{{{
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
"}}}
"=====================================================================================================
"drawit_con 其中'\'是默认的<leader>键
"{{{
"\di to start DrawIt and
"\ds to stop  DrawIt.
"|| \a           | draw arrow from corners of visual-block selected region   ||  |drawit-a|
"|| \b           | draw box on visual-block selected region                  ||  |drawit-b|
"|| \c           | the canvas routine (will query user, see above)           ||  |drawit-c|
"|| \e           | draw an ellipse on visual-block selected region           ||  |drawit-e|
"|| \f           | flood figure with a character (you will be prompted)      ||  |drawit-f|
"|| \l           | draw line from corners of visual-block selected region    ||  |drawit-l|
"|| \s           | spacer: appends spaces up to the textwidth (default: 78)  ||  |drawit-s|

"}}}
"=====================================================================================================
"emacs
"{{{
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
"}}}
"=====================================================================================================
"visul star
"{{{
"*查找当前选择的文本 #反向  也可以通过visul star search 插件实现
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>
function! s:VSetSearch()
    let temp =@s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s,'/\'),'\n','\\n', 'g')
    let @s = temp
endfunction
"}}}
"=====================================================================================================
" Others
"{{{
let g:UltiSnipsExpandTrigger="<leader><tab>"
"let g:ultisnipsjumpforwardtrigger="<leader><tab>"
"let g:ultisnipsjumpbackwardtrigger="<leader><s-tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
inoremap <leader>; <C-x><C-o>
"}}}
"=====================================================================================================
"
