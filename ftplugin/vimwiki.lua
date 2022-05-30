if vim.g.custom_filetype_vimwiki then
    return
end
vim.g.custom_filetype_vimwiki = true
-- default glow highlight
vim.cmd[[ 
    highlight VimwikiDelText gui=strikethrough guifg=#5c6370 guibg=background
    highlight link VimwikiCheckBoxDone VimwikiDelText
    hi MdList guifg=#00afff guibg=NONE ctermbg=NONE gui=bold cterm=bold
    hi MdCiteLevel1 guifg=#fc5e5e guibg=NONE ctermbg=NONE gui=bold cterm=bold
    hi MdCiteLevel2 guifg=#fc5e5e guibg=NONE ctermbg=NONE gui=bold cterm=bold
    hi MdCiteLevel3 guifg=#fc5e5e guibg=NONE ctermbg=NONE gui=bold cterm=bold
    hi VimwikiHeader1 guifg=#FFFF87 guibg=#5f5fff ctermbg=NONE gui=bold cterm=bold
    hi VimwikiHeader2 guifg=#00afff guibg=NONE ctermbg=NONE gui=bold cterm=bold
    hi VimwikiHeader3 guifg=#00afff guibg=NONE ctermbg=NONE gui=bold cterm=bold
    hi VimwikiHeader4 guifg=#00afff guibg=NONE ctermbg=NONE gui=bold cterm=bold
    hi VimwikiHeader5 guifg=#00afff guibg=NONE ctermbg=NONE gui=bold cterm=bold
    hi VimwikiCode guifg=#fc5e5e guibg=#303030 ctermbg=NONE
    hi VimwikiLink guifg=#177Fee guibg=NONE ctermbg=NONE gui=underline cterm=underline
    hi VimwikiHeaderChar guifg=#5c6370 ctermfg=241 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
    hi VimwikiHR guifg=#ebcb8b ctermfg=222 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
    hi VimwikiList guifg=#d08770 ctermfg=173 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
    hi VimwikiTag guifg=#d08770 ctermfg=173 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
    hi VimwikiMarkers guifg=#5c6370 ctermfg=241 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
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
    endif
]]


vim.cmd[[ 
function! VVimwiki_create_dir() abort
python3 << EOF
import math
import os
start_row, start_col = list(vim.current.buffer.mark('<'))
end_row, end_col = list(vim.current.buffer.mark('>'))
cur_line = list(vim.current.buffer[start_row-1])
name = ''.join(cur_line[start_col:end_col+1])
dir_name = '_'.join(name.split(' ')).strip()
file_name = "index.md"
if os.path.isdir(dir_name):
    pass
else:
    os.mkdir(dir_name)

cur_line[start_col:end_col+1] = f"[{name}]({os.path.join(dir_name, file_name)})"
vim.current.buffer[start_row-1] = ''.join(cur_line)
EOF
endfunction


function! NVimwiki_create_dir() abort
python3 << EOF
import os
cword = vim.eval('expand("<cWORD>")')
dir_name = '_'.join(cword.split())
file_name = "index.md"
if os.path.isdir(dir_name):
    pass
else:
    os.mkdir(dir_name)
cword = f"[{cword}]({os.path.join(dir_name, file_name)})"
vim.command("normal viwc%s" % cword)
EOF
endfunction
]]
