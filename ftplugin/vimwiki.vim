if exists('g:filetype_vimwiki_user')
  finish
endif
let g:filetype_vimwiki_user = 1
highlight VimwikiDelText gui=strikethrough guifg=#5c6370 guibg=background
highlight link VimwikiCheckBoxDone VimwikiDelText

function! VVimwiki_create_dir() abort
python3 << EOF
import math
import os
start_row, start_col = list(vim.current.buffer.mark('<'))
end_row, end_col = list(vim.current.buffer.mark('>'))
cur_line = list(vim.current.buffer[start_row-1])
name = ''.join(cur_line[start_col:end_col+1])
dir_name = '_'.join(name.split(' ')).strip()
file_name = dir_name
if os.path.isdir(dir_name):
    pass
else:
    os.mkdir(dir_name)

cur_line[start_col:end_col+1] = "[{}]({})".format(name, os.path.join(dir_name, file_name))
vim.current.buffer[start_row-1] = ''.join(cur_line)
EOF
endfunction


function! NVimwiki_create_dir() abort
python3 << EOF
import os
cword = vim.eval('expand("<cWORD>")')
dir_name = '_'.join(cword.split())
if os.path.isdir(dir_name):
    pass
else:
    os.mkdir(dir_name)
cword = "[{}]({})".format(cword, os.path.join(dir_name, dir_name))
vim.command("normal viwc%s" % cword)
EOF
endfunction

"command! -buffer VimwikiCreateDir call Vimwiki_create_dir()
vnoremap <unique><silent> <leader><cr> :call VVimwiki_create_dir()<cr>
nnoremap <unique><silent> <leader><cr> :call NVimwiki_create_dir()<cr>
"let g:vimwiki_listsyms = '✗○◐●✓'

"agenda & todo capture
"
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


"let g:vimwiki_hl_headers=1
"let g:vimwiki_hl_cb_checked=2
"hi VimwikiHeader1 guifg=#F4B6DB gui=bold
"hi VimwikiHeader2 guifg=#FFE46B gui=bold
"hi VimwikiHeader3 guifg=#78FF81 gui=bold
"hi VimwikiHeader4 guifg=#A7E8E2 gui=bold
"hi VimwikiHeader5 guifg=#9F79EE gui=bold
if g:colorscheme == 'gruvbox' || g:colorscheme == 'gruvbox_material'
    hi VimwikiHeader1 guifg=#dF7785 guibg=NONE ctermbg=NONE gui=bold cterm=bold
    hi VimwikiHeader2 guifg=#6BbCb6 guibg=NONE ctermbg=NONE gui=bold cterm=bold
    hi VimwikiHeader3 guifg=#a5c3b7 guibg=NONE ctermbg=NONE gui=bold cterm=bold
    hi VimwikiHeader4 guifg=#dCa5a0 guibg=NONE ctermbg=NONE gui=bold cterm=bold
    hi VimwikiHeader5 guifg=#946e8d guibg=NONE ctermbg=NONE gui=bold cterm=bold
    hi VimwikiLink guifg=#1179e8 guibg=NONE ctermbg=NONE gui=underline cterm=underline
    hi VimwikiHeaderChar guifg=#4c5360 ctermfg=241 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
    hi VimwikiHR guifg=#dbbb7b ctermfg=222 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
    hi VimwikiList guifg=#c07760 ctermfg=173 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
    hi VimwikiTag guifg=#c07760 ctermfg=173 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
    hi VimwikiMarkers guifg=#4c5360 ctermfg=241 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
    
else
    hi VimwikiHeader1 guifg=#FF97A5 guibg=NONE ctermbg=NONE gui=bold cterm=bold
    hi VimwikiHeader2 guifg=#8BDCD6 guibg=NONE ctermbg=NONE gui=bold cterm=bold
    hi VimwikiHeader3 guifg=#C5E3D7 guibg=NONE ctermbg=NONE gui=bold cterm=bold
    hi VimwikiHeader4 guifg=#FCC5C0 guibg=NONE ctermbg=NONE gui=bold cterm=bold
    hi VimwikiHeader5 guifg=#b48ead guibg=NONE ctermbg=NONE gui=bold cterm=bold
    hi VimwikiLink guifg=#177Fee guibg=NONE ctermbg=NONE gui=underline cterm=underline
    hi VimwikiHeaderChar guifg=#5c6370 ctermfg=241 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
    hi VimwikiHR guifg=#ebcb8b ctermfg=222 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
    hi VimwikiList guifg=#d08770 ctermfg=173 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
    hi VimwikiTag guifg=#d08770 ctermfg=173 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
    hi VimwikiMarkers guifg=#5c6370 ctermfg=241 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
endif
 
 


""diary
"nnoremap <Leader>dt :VimwikiMakeDiaryNote<cr>
"nnoremap <Leader>dT :VimwikiTabMakeDiaryNote<cr>
"nnoremap <Leader>dy :VimwikiMakeYesterdayDiaryNote<cr>
"nnoremap <Leader>di :VimwikiDiaryIndex<cr>
"nnoremap <Leader>dg :VimwikiDiaryGenerateLinks<cr>

"map <leader>; <Plug>VimwikiToggleListItem
""format convert
"nnoremap <Leader>ch :Vimwiki2HTML<cr>
"nnoremap <Leader>cH :Vimwiki2HTMLBrowse<cr>


"nnoremap <leader>c* :VimwikiChangeSymbolTo *<CR>
"nnoremap <leader>c# :VimwikiChangeSymbolTo #<CR>
"nnoremap <leader>c- :VimwikiChangeSymbolTo -<CR>
"nnoremap <leader>c1 :VimwikiChangeSymbolTo 1.<CR>
"nnoremap <leader>cA :VimwikiChangeSymbolTo A)<CR>
"nnoremap <leader>ca :VimwikiChangeSymbolTo a)<CR>
"nnoremap <leader>ci :VimwikiChangeSymbolTo i)<CR>
        
"nnoremap <leader>cl* :VimwikiChangeSymbolInListTo *<CR>
"nnoremap <leader>cl# :VimwikiChangeSymbolInListTo #<CR>
"nnoremap <leader>cl- :VimwikiChangeSymbolInListTo -<CR>
"nnoremap <leader>cl1 :VimwikiChangeSymbolInListTo 1.<CR>
"nnoremap <leader>clA :VimwikiChangeSymbolInListTo A)<CR>
"nnoremap <leader>cla :VimwikiChangeSymbolInListTo a)<CR>
"nnoremap <leader>cli :VimwikiChangeSymbolInListTo i)<CR>
        
""delete 
"nnoremap <Leader>dd :VimwikiDeleteLink<cr>
        
""toggle !checkbox
nnoremap <localleader>tt :VimwikiToggleListItem<cr>
"nnoremap <Leader>td :VimwikiRemoveSingleCB<cr>
"nnoremap <Leader>tD :VimwikiRemoveCBInList<cr>
       
       
""table  
"nnoremap <leader>tc :VimwikiTable 

""link
"vnoremap <Leader>lc :VimwikiFollowLink<cr>
"vmap ++ @<Plug>VimwikiNormalizeLinkVisual
