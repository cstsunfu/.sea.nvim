"Unite
let mapleader=';'
"nnoremap <leader>uu :<C-u>Unite -direction=below -start-insert line<CR>
"nnoremap <leader>uf :<C-u>Unite -direction=below -start-insert file buffer file_rec<CR>
"nnoremap <leader>um :<C-u>Unite -direction=below -start-insert mapping<cr>
"nnoremap <leader>uc :<C-u>Unite -direction=below -start-insert colorscheme<cr>



"Denite
nnoremap <leader>uu :<C-u>Denite  line<CR>
nnoremap <leader>uf :<C-u>Denite  file buffer file_rec<CR>
nnoremap <leader>um :<C-u>Denite  unite:mapping<cr>
nnoremap <leader>uc :<C-u>Denite  colorscheme<cr>
nnoremap <leader>ur :<C-u>Denite  directory_mru file_mru<cr>
