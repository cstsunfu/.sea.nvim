if exists('g:filetype_vimwiki_user')
  finish
endif
let g:filetype_vimwiki_user = 1

let g:vimwiki_map_prefix='<leader>o'

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
hi VimwikiHeader1 guifg=#00FFFF
hi VimwikiHeader2 guifg=#7FFF00
hi VimwikiHeader3 guifg=#9F79EE
hi VimwikiHeader4 guifg=#7D26CD
hi VimwikiHeader5 guifg=#00AAAA
hi VimwikiHeader6 guifg=#AAAA00


"diary
nnoremap <Leader>dt :VimwikiMakeDiaryNote<cr>
nnoremap <Leader>dT :VimwikiTabMakeDiaryNote<cr>
nnoremap <Leader>dy :VimwikiMakeYesterdayDiaryNote<cr>
nnoremap <Leader>di :VimwikiDiaryIndex<cr>
nnoremap <Leader>dg :VimwikiDiaryGenerateLinks<cr>

map <leader>; <Plug>VimwikiToggleListItem
"format convert
nnoremap <Leader>ch :Vimwiki2HTML<cr>
nnoremap <Leader>cH :Vimwiki2HTMLBrowse<cr>


nnoremap <leader>c* :VimwikiChangeSymbolTo *<CR>
nnoremap <leader>c# :VimwikiChangeSymbolTo #<CR>
nnoremap <leader>c- :VimwikiChangeSymbolTo -<CR>
nnoremap <leader>c1 :VimwikiChangeSymbolTo 1.<CR>
nnoremap <leader>cA :VimwikiChangeSymbolTo A)<CR>
nnoremap <leader>ca :VimwikiChangeSymbolTo a)<CR>
nnoremap <leader>ci :VimwikiChangeSymbolTo i)<CR>
        
nnoremap <leader>cl* :VimwikiChangeSymbolInListTo *<CR>
nnoremap <leader>cl# :VimwikiChangeSymbolInListTo #<CR>
nnoremap <leader>cl- :VimwikiChangeSymbolInListTo -<CR>
nnoremap <leader>cl1 :VimwikiChangeSymbolInListTo 1.<CR>
nnoremap <leader>clA :VimwikiChangeSymbolInListTo A)<CR>
nnoremap <leader>cla :VimwikiChangeSymbolInListTo a)<CR>
nnoremap <leader>cli :VimwikiChangeSymbolInListTo i)<CR>
        
"delete 
nnoremap <Leader>dd :VimwikiDeleteLink<cr>
        
"toggle !checkbox
nnoremap <Leader>tt :VimwikiToggleListItem<cr>
nnoremap <Leader>td :VimwikiRemoveSingleCB<cr>
nnoremap <Leader>tD :VimwikiRemoveCBInList<cr>
       
       
"table  
nnoremap <leader>tc :VimwikiTable 

"link
vnoremap <Leader>lc :VimwikiFollowLink<cr>
vmap ++ @<Plug>VimwikiNormalizeLinkVisual
