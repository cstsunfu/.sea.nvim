" File              : vim_unite.vim
" Author            : Sun Fu <cstsunfu@gmail.com>
" Date              : 26.03.2018
" Last Modified Date: 26.03.2018
" Last Modified By  : Sun Fu <cstsunfu@gmail.com>
"Unite
let mapleader=';'
"nnoremap <leader>uu :<C-u>Unite -direction=below -start-insert line<CR>
"nnoremap <leader>uf :<C-u>Unite -direction=below -start-insert file buffer file_rec<CR>
"nnoremap <leader>um :<C-u>Unite -direction=below -start-insert mapping<cr>
"nnoremap <leader>uc :<C-u>Unite -direction=below -start-insert colorscheme<cr>


let s:denite_options = {
      \ 'default' : {
      \ 'winheight' : 15,
      \ 'mode' : 'insert',
      \ 'quit' : 'true',
      \ 'highlight_matched_char' : 'MoreMsg',
      \ 'highlight_matched_range' : 'MoreMsg',
      \ 'direction': 'rightbelow',
      \ 'statusline' : has('patch-7.4.1154') ? v:false : 0,
      \ 'prompt' : '▶▶▶',
      \ }}
function! s:profile(opts) abort
  for fname in keys(a:opts)
    for dopt in keys(a:opts[fname])
      call denite#custom#option(fname, dopt, a:opts[fname][dopt])
    endfor
  endfor
endfunction

call s:profile(s:denite_options)
" KEY MAPPINGS
let s:insert_mode_mappings = [
      \  ['jk', '<denite:enter_mode:normal>', 'noremap'],
      \ ['<Tab>', '<denite:move_to_next_line>', 'noremap'],
      \ ['<S-tab>', '<denite:move_to_previous_line>', 'noremap'],
      \ ['<C-j>', '<denite:move_to_next_line>', 'noremap'],
      \ ['<C-k>', '<denite:move_to_previous_line>', 'noremap'],
      \  ['<Esc>', '<denite:quit>', 'noremap'],
      \  ['<C-N>', '<denite:assign_next_matched_text>', 'noremap'],
      \  ['<C-P>', '<denite:assign_previous_matched_text>', 'noremap'],
      \  ['<Up>', '<denite:assign_previous_text>', 'noremap'],
      \  ['<Down>', '<denite:assign_next_text>', 'noremap'],
      \  ['<C-Y>', '<denite:redraw>', 'noremap'],
      \ ]

let s:normal_mode_mappings = [
      \   ["'", '<denite:toggle_select_down>', 'noremap'],
      \   ['<C-n>', '<denite:jump_to_next_source>', 'noremap'],
      \   ['<C-p>', '<denite:jump_to_previous_source>', 'noremap'],
      \   ['gg', '<denite:move_to_first_line>', 'noremap'],
      \   ['st', '<denite:do_action:tabopen>', 'noremap'],
      \   ['sg', '<denite:do_action:vsplit>', 'noremap'],
      \   ['sv', '<denite:do_action:split>', 'noremap'],
      \   ['q', '<denite:quit>', 'noremap'],
      \   ['r', '<denite:redraw>', 'noremap'],
      \ ]

for s:m in s:insert_mode_mappings
  call denite#custom#map('insert', s:m[0], s:m[1], s:m[2])
endfor
for s:m in s:normal_mode_mappings
  call denite#custom#map('normal', s:m[0], s:m[1], s:m[2])
endfor

unlet s:m s:insert_mode_mappings s:normal_mode_mappings
"Denite
nnoremap <leader>uu :<C-u>Denite  line<CR>
nnoremap <leader>uf :<C-u>Denite  file buffer file_rec<CR>
nnoremap <leader>ub :<C-u>Denite  buffer<CR>
nnoremap <leader>um :<C-u>Denite  unite:mapping<cr>
nnoremap <leader>uc :<C-u>Denite  colorscheme<cr>
nnoremap <leader>ur :<C-u>Denite  file_mru buffer<cr>
