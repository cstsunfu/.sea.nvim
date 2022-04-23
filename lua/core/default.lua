-- setting map leader
vim.cmd("let maplocalleader=','")
vim.cmd("let mapleader=';'")
vim.cmd("nnoremap \\ ;")
vim.cmd("vnoremap \\ ;")
local global_func = require('util.global')

default_setting = {}

-- special setting

vim.cmd("hi CursorLine term=bold cterm=bold guibg=Grey40") -- cursorline color

global_func.augroup('smarter_cursorline', {
    {
        events = {'InsertLeave' , 'WinEnter', 'VimEnter', 'BufEnter', 'BufWinEnter', 'BufNew'},
        targets = {'*'},
        command = "set cursorline"
    },
    {
        events = {'InsertEnter' , 'WinLeave' },
        targets = {'*'},
        command = "set nocursorline"
    },
    {
        events = {'InsertEnter' },
        targets = {'*'},
        command = "set norelativenumber"
    },
    {
        events = {'InsertLeave' },
        targets = {'*'},
        command = "set relativenumber"
    },

})

global_func.augroup('empty_message', {
    {
        events = {'CursorHold' },
        targets = {'*'},
        command = ":echo "
    },

})


default_setting['opt'] = {
    number = true,
    --relativenumber = true,                    -- has moved to smarter_cursorline autocmd
    --
    backupdir = "$XDG_DATA_HOME/nvim/backup/",  -- no backup inplace
    --fillchars = "fold:-,eob: ,vert: ",          -- fillchars , fold for fold fillchars, eob for the end file begin fillchars, vert for vert split
    fillchars = "fold:-,eob: ,vert:▕",          -- fillchars , fold for fold fillchars, eob for the end file begin fillchars, vert for vert split
    --"│⎟⎜⎜⎢⎜▏▊▋▉"
    --"▕"
    --https://unicode-table.com/en/
    --fillchars = "fold:-,eob: ,vert:▎",          -- fillchars , fold for fold fillchars, eob for the end file begin fillchars, vert for vert split
	
    --vim.cmd("set fillchars=fold:\\-,eob:\\ ,vert:│") -- fillchars , fold for fold fillchars, eob for the end file begin fillchars, vert for vert split
    history = 10000,                            -- undo file history
    undofile = true,                            -- use undo file
    swapfile = false,                            -- use swap file
    maxmempattern = 2000,                       -- max match pattern
    autochdir = true,                           -- auto change directory to current file
    lazyredraw = true,                          -- true will speed up in macro repeat
    ttyfast = true,                             -- true maybe as lazyredraw ? TODO
    mouse = 'a',
    hidden = true,                              -- permit of change buffer when the buffer is not been written
    syntax = 'on',                              -- permit change default syntax
    fileencodings = "utf-8,ucs-bom,gb18030,gbk,gb2312,cp936,latin1",
    encoding = "utf-8",
    path = vim.o.path .. ",./**",
    omnifunc='v:lua.vim.lsp.omnifunc',          -- TODO: just donot remamble what this mean
    tabstop = 4,                                -- replace tab as white space
    expandtab = true,
    shiftwidth = 4,
    conceallevel = 2,
    concealcursor = '',                         -- if set to nc, char will always fold except in insert mode
    softtabstop = 4,
    foldenable = true,                          -- enable fold
    foldlevel = 99,                             -- disable fold for opened file
    foldminlines = 0,                           -- even the child is only one line, fold always works
    foldmethod = 'expr',                        -- for most filetype, fold by syntax
    foldnestmax = 5,                            -- max fold nest
    foldexpr = "nvim_treesitter#foldexpr()",
    completeopt = "menuone,noselect",
    --t_ut = " ",                               -- disable Backgroud color Erase（BCE）
    termguicolors = true,                       -- TODO
    colorcolumn = "99999"                       -- FIXED: for https://github.com/lukas-reineke/indent-blankline.nvim/issues/59
}

default_setting['global'] = {
    --python3_host_prog = '/usr/bin/python3'

}

for key, value in pairs(default_setting['opt']) do
    vim.o[key] = value
end

for key, value in pairs(default_setting['global']) do
    vim.g[key] = value
end
