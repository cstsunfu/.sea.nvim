" File              : after.vim
" Author            : Sun Fu <cstsunfu@gmail.com>
" Date              : 20.03.2018
" Last Modified Date: 26.03.2019
" Last Modified By  : Sun Fu <cstsunfu@gmail.com>
if exists('g:load_indentline') && g:load_indentline
    "{{{indent line
    let g:indentLine_fileType=['c', 'cpp', 'python', 'vim', 'tex']
    let g:indentLine_color_term = 239
    let g:indentLine_color_gui='#565656'
    "let g:indentLine_color_gui='#8E388E'
    "let g:indentLine_char='|'
    " Background (Vim, GVim)
    let g:indentLine_bgcolor_term = 180
    "let g:indentLine_bgcolor_gui = 
    "let g:indentLine_char_list = ['|', '¦', '┆', '┊']
    let g:indentLine_char_list = ['¦']
    "hi CursorLine term=bold cterm=bold guibg=Grey30
    "}}}
endif

if exists('g:load_smooth_scroll') && g:load_smooth_scroll
    nmap j <Plug>(accelerated_jk_gj)
    nmap k <Plug>(accelerated_jk_gk)
endif

if exists('g:load_org_my_life') && g:load_org_my_life
    au BufEnter *.dotoo exec "set ft=dotoo"
endif

"{{{ 基于缩进或语法进行代码折叠
"set foldmethod=marker
set foldenable
set foldmethod=syntax
"set foldmethod=indent
au BufEnter *.py setlocal foldmethod=indent 
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

let g:vimwiki_folding='custom'
"au BufEnter *.md setlocal 
            "\ foldmethod=expr 
            "\ foldexpr=MarkdownLevel()  

" Default to Vimwiki's section folding options
autocmd FileType vimwiki setlocal
      \ fdm=expr
      \ foldexpr=MarkdownLevel()
      \ foldtext=VimwikiFoldText()



au BufEnter *.vim setlocal foldmethod=marker 
augroup filetype_fold
    autocmd FileType startify setlocal nofoldenable
    autocmd BufRead,BufNewFile info.* setlocal nofoldenable
augroup END
"za 打开或关闭折叠 zM，关闭所有折叠，zR，打开所有折叠
" silen
nnoremap <silent><leader><tab> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
set foldopen     -=hor
set foldopen     +=jump
set foldtext      =mhi#foldy()
"}}}

nnoremap <silent><leader><tab> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>
set foldopen     -=hor
set foldopen     +=jump
set foldtext      =mhi#foldy()
"}}}
"{{{ UI
"
    "set fillchars+=vert:\        "修改分割线为空格 
    set fillchars+=vert:│
    "set fillchars+=eob:\ 
    "set fillchars+=stl:-
    "不显示~
    hi NonText guifg=bg

    hi FZFBorder ctermfg=Black guifg=#7B68EE
    ""hi FZFBorder ctermfg=Black guifg=Black
"}}}


fu s:set_split_bg_fg() abort
    "hi VertSplit ctermbg=NONE guibg=string(synIDattr(hlID("Normal"), "bg"))
    "hi VertSplit ctermbg=NONE guibg=dark
    hi VertSplit ctermfg=black guifg=black
    "hi StatusLine ctermbg=NONE guibg=string(synIDattr(hlID("Normal"), "bg"))
    "hi StatusLine ctermbg=NONE guibg=dark
    hi StatusLine ctermfg=black guifg=black
endfu

if exists('g:load_colorschemes') && g:load_colorschemes && g:colors_name == 'OceanicNext'
    exec 'hi VertSplit ctermbg=Black guibg=Black'
elseif g:colors_name == 'dracula'
    hi VertSplit guifg=#282a36 guibg=black
    "hi StatusLine ctermfg=black guifg=black
else
    exec 'call s:set_split_bg_fg()'
endif
