" File              : vimwiki.vim
" Author            : Sun Fu <cstsunfu@gmail.com>
" Date              : 05.12.2018
" Last Modified Date: 11.04.2019
" Last Modified By  : Sun Fu <cstsunfu@gmail.com>
"vimwiki
let g:vimwiki_map_prefix='<leader>o'
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



let g:vimwiki_folding='list'
let g:vimwiki_folding+='expr'
let g:vimwiki_folding+='syntax'
let g:vimwiki_hl_headers=1
let g:vimwiki_hl_cb_checked=2
"let g:vimwiki_html_header_numbering_sym = ' '
"let g:vimwiki_html_header_numbering = 2
hi VimwikiHeader1 guifg=#FF0000
hi VimwikiHeader2 guifg=#00FF00
hi VimwikiHeader3 guifg=#0000FF
hi VimwikiHeader4 guifg=#FF00FF
hi VimwikiHeader5 guifg=#00FFFF
hi VimwikiHeader6 guifg=#FFFF00


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
"vnoremap <leader>lc :VimwikiNormalizeLinkVisual<cr>
vmap ++ @<Plug>VimwikiNormalizeLinkVisual
