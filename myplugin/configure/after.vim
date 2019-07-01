" File              : after.vim
" Author            : Sun Fu <cstsunfu@gmail.com>
" Date              : 20.03.2018
" Last Modified Date: 26.03.2019
" Last Modified By  : Sun Fu <cstsunfu@gmail.com>
"================================================================================================================
"UI
    set fillchars+=vert:\        "修改分割线为空格 
    hi VertSplit ctermbg=NONE guibg=NONE
    hi VertSplit ctermfg=black guifg=black
    hi StatusLine ctermbg=NONE guibg=NONE
    hi StatusLine ctermfg=black guifg=black
    set fillchars+=vert:│
    "set fillchars+=eob:\ 
    "set fillchars+=stl:-
    "不显示~
    hi NonText guifg=bg

"================================================================================================================
" indentLine
"
    let g:indentLine_fileType=['c', 'cpp', 'python', 'vim', 'tex']
    let g:indentLine_color_term = 239
    "let g:indentLine_color_gui='#A4E57E'
    let g:indentLine_color_gui='#8E388E'
    "let g:indentLine_char='|'
    " Background (Vim, GVim)
    let g:indentLine_bgcolor_term = 180
    let g:indentLine_bgcolor_gui = '0'
    let g:indentLine_char='│'
    hi CursorLine term=bold cterm=bold guibg=Grey30

"================================================================================================================
