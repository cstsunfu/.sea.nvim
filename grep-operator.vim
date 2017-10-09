"nnoremap <leader>g :silent execute "grep! -R " . shellescape(expand("<cWORD")) . " ."<cr>:copen<cr>
nnoremap <leader>g :set operatorfunc=<SIG>GrepOperator<cr>g@
vnoremap <leader>g :<c-u>call <SIG>GrepOperator(visualmode())<cr>

function! s:GrepOperator(type)
    let saved_unnamed_register=@@
    if a:type==# 'v'
        execute "normal! `<v`>y"
    elseif a:type==#'char'
        execute "normal! `[v`]y"
    else
        return
    endif
    
    silent execute "grep! -R " . shellescape(@@) . " %"
    copen

    let @@=saved_unnamed_register
endfunction


