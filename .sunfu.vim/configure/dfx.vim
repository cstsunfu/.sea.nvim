if exists('g:loaded_defx_configure')
  finish
endif
let g:loaded_defx_configure = 1


"nnoremap <silent><leader>fo :call <sid>defx_open({ 'split': v:true, 'find_current_file': v:true })<CR>

let s:default_columns = 'indent:git:icons:filename'

function! configure#dfx#setup_defx() abort
    call defx#custom#option('_', {
                \ 'columns': s:default_columns,
                \ })

    call defx#custom#column('filename', {
                \ 'min_width': 80,
                \ 'max_width': 80,
                \ })

    call configure#dfx#defx_open({ 'dir': expand('<afile>') })
endfunction

function! s:get_project_root() abort
    "{{{
    let l:git_root = ''
    let l:path = expand('%:p:h')
    let l:cmd = systemlist('cd '.l:path.' && git rev-parse --show-toplevel')
    if !v:shell_error && !empty(l:cmd)
        let l:git_root = fnamemodify(l:cmd[0], ':p:h')
    endif

    if !empty(l:git_root)
        return l:git_root
    endif

    return getcwd()
    "}}}
endfunction

function! configure#dfx#defx_open(...) abort
    "{{{
    let l:opts = get(a:, 1, {})
    let l:path = get(l:opts, 'dir', s:get_project_root())

    if !isdirectory(l:path) || &filetype ==? 'defx'
        return
    endif

    let l:args = '-winwidth=30 -direction=botright'
    "let l:args = '-winwidth=25 -direction=topleft'

    if has_key(l:opts, 'split')
        let l:args .= ' -split=vertical'
    endif

    if has_key(l:opts, 'find_current_file')
        if &filetype ==? 'defx'
            return
        endif
        call execute(printf('Defx %s -search=%s %s', l:args, expand('%:p'), l:path))
    else
        if defx#is_opened_tree()
            call excute('Defx')
            call excute('q')
        else
            call execute(printf('Defx -toggle %s %s', l:args, l:path))
            call execute('wincmd p')
        endif
    endif

    return execute("norm!\<C-w>=")
    "}}}
endfunction

function! s:defx_context_menu() abort
    let l:actions = ['new_multiple_files', 'rename', 'copy', 'move', 'paste', 'remove']
    let l:selection = confirm('Action?', "&New file/directory\n&Rename\n&Copy\n&Move\n&Paste\n&Delete")
    silent exe 'redraw'

    return feedkeys(defx#do_action(l:actions[l:selection - 1]))
endfunction

function! s:defx_toggle_tree() abort
    if defx#is_directory()
        return defx#do_action('open_or_close_tree')
    endif
    return defx#do_action('drop')
endfunction

function! configure#dfx#defx_my_settings() abort
    " Define mappings
    "{{{
    "nnoremap <silent><buffer><expr> <CR>
                "\ defx#do_action('open')

    nnoremap <silent><buffer><expr> <CR>
                \ defx#is_directory() ?
                \ defx#do_action('open_directory') :
                \ defx#do_action('multi', ['drop', 'quit'])
    nnoremap <silent><buffer><expr> c
                \ defx#do_action('copy')
    nnoremap <silent><buffer><expr> m
                \ defx#do_action('move')
    nnoremap <silent><buffer><expr> p
                \ defx#do_action('paste')
    nnoremap <silent><buffer><expr> l
                \ defx#is_directory() ? defx#do_action('open') :
                \ defx#do_action('multi', ['drop'])
    nnoremap <silent><buffer><expr> E
                \ defx#do_action('open', 'vsplit')
    nnoremap <silent><buffer><expr> P
                \ defx#do_action('open', 'pedit')
    nnoremap <silent><buffer><expr> K
                \ defx#do_action('new_directory')
    nnoremap <silent><buffer><expr> N
                \ defx#do_action('new_file')
    nnoremap <silent><buffer><expr> d
                \ defx#do_action('remove')
    nnoremap <silent><buffer><expr> r
                \ defx#do_action('rename')
    nnoremap <silent><buffer><expr> x
                \ defx#do_action('execute_system')
    nnoremap <silent><buffer><expr> yy
                \ defx#do_action('yank_path')
    nnoremap <silent><buffer><expr> .
                \ defx#do_action('toggle_ignored_files')
    nnoremap <silent><buffer><expr> h
                \ defx#do_action('cd', ['..'])
    nnoremap <silent><buffer><expr> ~
                \ defx#do_action('cd')
    nnoremap <silent><buffer><expr> q
                \ defx#do_action('quit')
    nnoremap <silent><buffer><expr> <Space>
                \ defx#do_action('toggle_select') . 'j'
    nnoremap <silent><buffer><expr> *
                \ defx#do_action('toggle_select_all')
    nnoremap <silent><buffer><expr> j
                \ line('.') == line('$') ? 'gg' : 'j'
    nnoremap <silent><buffer><expr> k
                \ line('.') == 1 ? 'G' : 'k'
    nnoremap <silent><buffer><expr> <C-l>
                \ defx#do_action('redraw')
    nnoremap <silent><buffer><expr> <C-g>
                \ defx#do_action('print')
    nnoremap <silent><buffer><expr> <CR>
        \ defx#is_directory() ? defx#do_action('open') :
        \ defx#do_action('multi', ['drop'])
        "\ defx#do_action('multi', ['drop', 'quit'])

    nnoremap <silent><buffer><expr> o <sid>defx_toggle_tree()
    nnoremap <silent><buffer><expr> O defx#do_action('open_tree_recursive')
endfunction

autocmd VimEnter * call configure#dfx#setup_defx()
autocmd FileType defx call configure#dfx#defx_my_settings()
