if exists('g:loaded_airline_configure')
  finish
endif
let g:loaded_airline_configure = 1
if exists('g:load_airline') && g:load_airline
    "{{{ airline
    let g:airline#extensions#tabline#ignore_bufadd_pat = 'gundo|undotree|vimfiler|tagbar|nerd_tree|!'
    "这个是安装字体后 必须设置此项" 
    let g:airline_powerline_fonts = 1   
    "let g:airline#extensions#tabline#fnamemod = ':t'
    "打开tabline功能, 方便查看Buffer和切换, 省去了minibufexpl插件
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#buffer_idx_mode = 1
    if g:colors_name == 'space-vim-dark'
        let g:airline_theme='violet'
    elseif g:colors_name == 'one'
        let g:airline_theme='violet'
    elseif g:colors_name == 'gruvbox'
        let g:airline_theme='gruvbox'
    elseif g:colors_name == 'NeoSolarized'
        let g:airline_theme='angr'
    elseif g:colors_name == 'oceanicnext'
        let g:airline_theme='oceanicnext'
    elseif g:colors_name == 'challenger_deep'
        let g:airline_theme='oceanicnext'
    elseif g:colors_name == 'atom-dark'
        let g:airline_theme='challenger_deep'
    elseif g:colors_name == 'palenight'
        let g:airline_theme='palenight'
    endif
    "let g:airline_theme='base16'
    "let g:airline#extensions#ale#enabled = 1    "ale error or warning
    "airline set the window number
    "let g:airline_theme='gruvbox'
    "
    "
    let g:airline_powerline_fonts = 1
    let g:airline#extensions#tabline#enabled = 1
    "let g:airline#extensions#ale#enabled = 1
    let g:airline#extensions#tabline#tab_nr_type = 1 " tab number
    let g:airline#extensions#tabline#show_tab_nr = 1
    let g:airline#extensions#tabline#formatter = 'default'
    let g:airline#extensions#tabline#buffer_nr_show = 0
    let g:airline#extensions#tabline#fnametruncate = 16
    let g:airline#extensions#tabline#fnamecollapse = 2
    let g:airline#extensions#tabline#buffer_idx_mode = 1
    let g:airline#extensions#tabline#fnamemod = ':p:t'
    "let g:airline_section_z = '%3p%% %3l/%L:%3v'
    let g:airline_section_z = '%3l/%L'
    "let g:airline#extensions#hunks#enabled = 0
    let g:airline_section_error = '%{airline#util#wrap( airline#extensions#coc#get_error(), 0)}'
    let g:airline_section_warning = '%{airline#util#wrap( airline#extensions#coc#get_warning(), 0)}'
    let g:airline#extensions#tabline#buffer_idx_format = {
            \ '-': '➓ ',
            \ '1': '❶ ',
            \ '2': '❷ ',
            \ '3': '❸ ',
            \ '4': '❹ ',
            \ '5': '❺ ',
            \ '6': '❻ ',
            \ '7': '❼ ',
            \ '8': '❽ ',
            \ '9': '❾ ',
            \ '0': '➓ ',
            \}
    let g:airline_detect_modified=1
    let g:airline_detect_paste=1
    let g:airline_detect_crypt=1
    let g:airline_highlighting_cache = 1

    let g:airline_filetype_overrides = {
        \ 'defx':  ['Dir', '%{b:defx.paths[0]}'],
        \ 'gundo': [ 'Gundo', '' ],
        \ 'help':  [ 'Help', '%f' ],
        \ 'minibufexpl': [ 'MiniBufExplorer', '' ],
        \ 'nerdtree': [ get(g:, 'NERDTreeStatusline', 'NERD'), '' ],
        \ 'vim-plug': [ 'Plugins', '' ],
        \ 'vimfiler': [ 'vimfiler', '%{vimfiler#get_status_string()}' ],
        \ 'vimshell': ['vimshell','%{vimshell#get_status_string()}'],
        \ 'startify': [ ' · 晴 﫥  ', '无用之用 方为大用 《庄子·人间世》' , '投币三连'],
        \ }
            "  ﭾ  
        "\ 'startify': [ ' ﭾ ', '无用之用 方为大用 《庄子·人间世》' , '投币三连'],
        "\ 'startify': [ '  ', '无用之用 方为大用 《庄子·人间世》' , '投币三连'],
        "\ 'startify': [ '晴 﫥  ', '无用之用 方为大用 《庄子·人间世》' , '投币三连'],
    "let g:airline#extensions#tabline#ignore_bufadd_pat = 'gundo|undotree|vimfiler|tagbar|nerd_tree|!'
    let g:airline#extensions#tabline#ignore_bufadd_pat='!|defx|gundo|nerd_tree|tagbar|undotree|vimfiler'
    "}}}
endif

