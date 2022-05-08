-- special setting
--
local timer = vim.loop.new_timer()
timer:start(vim.g.after_schedule_time_start, 0, vim.schedule_wrap(function()
    vim.cmd("hi! link SignColumn LineNr") --set VertSplit color to black
    vim.cmd("autocmd ColorScheme, VimEnter * highlight! link SignColumn LineNr")

    vim.cmd("hi! VertSplit ctermfg=black guifg=black") --set VertSplit color to black
    vim.cmd("hi! StatusLine ctermfg=black guifg=black") --set HSplit color to black
    vim.cmd("hi! clear WhichKeyDesc")
    vim.cmd("hi! WhichKeyDesc guifg=#76ACED")
end))
