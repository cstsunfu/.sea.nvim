local default_setting = {}


default_setting['global'] = {
    after_schedule_time_start = 500,
}

-- setting map leader
vim.cmd("let maplocalleader=','")
vim.cmd("let mapleader=';'")
vim.cmd("nnoremap \\ ;")
vim.cmd("vnoremap \\ ;")
local global_func = require('util.global')


-- special setting

--vim.cmd("hi CursorLine term=bold cterm=bold guibg=Grey40") -- cursorline color

vim.g.side_filetypes = { -- Specify which filetypes get the contrasted (darker) background
    --"terminal", -- Darker terminal background
    "packer", -- Darker packer background
    "NvimTree",
    "ctrlsf",
    "calendar",
    "undotree",
    "toggleterm",
    "DiffviewFiles",
    "diff",
    "Outline",
    "vista",
    "vista_kind",
    "dapui_stacks",
    "dapui_breakpoints",
    "dapui_watches",
    "dapui_scopes",
    "vista_markdown",
    "qf" -- Darker qf list background
}

local no_number_filetypes = {
    Telescope = true,
    dashboard = true,
    dapui_console = true,
    ['dap-repl'] = true,
    help = true,
}
for _,filetype in ipairs(vim.g.side_filetypes) do
    no_number_filetypes[filetype] = true
end
no_number_filetypes[''] = true

vim.g.no_number_filetypes = no_number_filetypes

local no_number_filetypes_list = {} -- if set vim.g.no_number_filetypes_list = {}, cannot insert as list
for key, _ in pairs(vim.g.no_number_filetypes) do
    table.insert(no_number_filetypes_list, key)
end

vim.g.no_number_filetypes_list = no_number_filetypes_list
vim.g.no_number_filetypes_concat_list = table.concat(no_number_filetypes_list, ',')


_G.check_zen_mode_start = function()
    local loaded_module = require('core.plugins').all_loaded_module
    if loaded_module.zen_mode ~= true then
        return false
    end
    return require('zen-mode.view').is_open()
end

global_func.augroup('smarter_cursorline', {
    {
        events = { 'filetype' },
        targets = { vim.g.no_number_filetypes_concat_list },
        command = "setlocal nonumber"
    },
    {
        events = { 'filetype' },
        targets = { vim.g.no_number_filetypes_concat_list },
        command = "setlocal norelativenumber"
    },
    {
        events = { 'InsertLeave', 'WinEnter', 'VimEnter', 'BufEnter', 'BufWinEnter', 'BufNew' },
        targets = { '*' },
        command = "set cursorline"
    },
    {
        events = { 'InsertEnter', 'WinLeave' },
        targets = { '*' },
        command = "set nocursorline"
    },
    {
        events = { 'InsertEnter' },
        targets = { '*' },
        command = "set norelativenumber"
    },
    {
        events = { 'InsertLeave', 'BufEnter' },
        targets = { '*' },
        --command = [[ lua if vim.g.no_number_filetypes[vim.bo.filetype] == nil and vim.api.nvim_win_get_config(0).relative == '' then vim.o.relativenumber = true vim.o.number = true end ]]
        command = [[ lua if vim.g.no_number_filetypes[vim.bo.filetype] == nil and (vim.api.nvim_win_get_config(0).relative == '' or _G.check_zen_mode_start()) then vim.o.relativenumber = true vim.o.number = true end ]]
    },
})


--global_func.augroup('empty_message', {
--    {
--        events = { 'CursorHold' },
--        targets = { '*' },
--        command = ":echo "
--    },

--})

default_setting['opt'] = {
    number = true,
    guicursor = 'n-v:block-Cursor,i-ci-ve-c:ver25-Cursor', --block for normal visual mode, vertical for insert command mode. highlight set to Cursor
    --relativenumber = true, -- set in autocmd
    --fillchars = "fold:-,eob: ,vert: ",          -- fillchars , fold for fold fillchars, eob for the end file begin fillchars, vert for vert split
    fillchars = "fold:-,eob: ,vert:▕,diff: ", -- fillchars , fold for fold fillchars, eob for the end file begin fillchars, vert for vert split
    --"│⎟⎜⎜⎢⎜▏▊▋▉▕   ref: https://unicode-table.com/en
    history = 10000, -- undo file history
    updatetime = 30, -- CursorHold
    undofile = true, -- use undo file
    swapfile = true, -- use swap file
    maxmempattern = 2000, -- max match pattern
    autochdir = true, -- auto change directory to current file
    lazyredraw = true, -- true will speed up in macro repeat
    ttyfast = true, -- true maybe as lazyredraw ? TODO
    mouse = 'a',
    hidden = true, -- permit of change buffer when the buffer is not been written
    fileencodings = "utf-8,ucs-bom,gb18030,gbk,gb2312,cp936,latin1",
    encoding = "utf-8",
    path = vim.o.path .. ",./**",
    omnifunc = 'v:lua.vim.lsp.omnifunc', -- for default lsp
    tabstop = 4, -- replace tab as white space
    mousemoveevent = true,
    expandtab = true,
    shiftwidth = 4,
    conceallevel = 2,
    concealcursor = '', -- if set to nc, char will always fold except in insert mode
    softtabstop = 4,
    foldenable = true, -- enable fold
    foldlevel = 99, -- disable fold for opened file
    foldminlines = 0, -- 0 means even the child is only one line, fold always works
    foldmethod = 'syntax', -- for most filetype, fold by syntax
    foldnestmax = 5, -- max fold nest
    --foldexpr = "nvim_treesitter#foldexpr()",
    completeopt = "menuone,noselect",
    --t_ut = " ",                               -- disable Backgroud color Erase（BCE）
    termguicolors = true, -- TODO
    colorcolumn = "99999" -- FIXED: for https://github.com/lukas-reineke/indent-blankline.nvim/issues/59
}

for key, value in pairs(default_setting['opt']) do
    vim.o[key] = value
end

for key, value in pairs(default_setting['global']) do
    vim.g[key] = value
end


local aug = vim.api.nvim_create_augroup("buf_large", { clear = true })

vim.api.nvim_create_autocmd({ "BufReadPre", "FileReadPre" }, {
    callback = function()
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
        if ok and stats and (stats.size > 100000) then
            vim.b.large_buf = true
            vim.cmd("syntax off")
            --vim.cmd("IlluminatePauseBuf") -- disable vim-illuminate
            vim.opt_local.foldmethod = "manual"
            if vim.fn.exists(":TSBufDisable") then
                vim.cmd('TSBufDisable autotag')
                vim.cmd('TSBufDisable highlight')
                vim.cmd('TSBufDisable incremental_selection')
                vim.cmd('TSBufDisable indent')
                vim.cmd('TSBufDisable playground')
                vim.cmd('TSBufDisable query_linter')
                vim.cmd('TSBufDisable rainbow')
                vim.cmd('TSBufDisable refactor.highlight_definitions')
                vim.cmd('TSBufDisable refactor.navigation')
                vim.cmd('TSBufDisable refactor.smart_rename')
                vim.cmd('TSBufDisable refactor.highlight_current_scope')
                vim.cmd('TSBufDisable textobjects.swap')
                vim.cmd('TSBufDisable textobjects.move')
                vim.cmd('TSBufDisable textobjects.lsp_interop')
                vim.cmd('TSBufDisable textobjects.select')
            end
            if vim.fn.exists(":TSBufDisable") then
                vim.cmd('TSBufDisable textobjects.select')
            end
            vim.opt_local.spell = false
        else
            vim.b.large_buf = false
        end
    end,
    group = aug,
    pattern = "*",
})

local active_group = vim.api.nvim_create_augroup("active_group", { clear = false })
vim.cmd('highlight link DarkNormal Normal')
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    callback = function()
        -- if filetype in 
        if global_func.index(vim.g.side_filetypes, vim.bo.filetype) == nil then
            vim.cmd('setl winhighlight=Normal:Normal')
            if vim.g.no_number_filetypes[vim.bo.filetype] == nil and vim.api.nvim_win_get_config(0).relative == '' then
                vim.cmd('setl relativenumber')
            end
        end
    end,
    group = active_group,
    pattern = "*",
})
vim.api.nvim_create_autocmd({ "WinLeave" }, {
    callback = function()
        if global_func.index(vim.g.side_filetypes, vim.bo.filetype) == nil then
            vim.cmd('setl winhighlight=Normal:DarkNormal')
            if vim.g.no_number_filetypes[vim.bo.filetype] == nil then
                vim.cmd('setl norelativenumber')
            end
        end
    end,
    group = active_group,
    pattern = "*",
})
