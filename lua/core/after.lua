-- special setting
local timer = vim.loop.new_timer()
local hl_fun = require('util.highlight')
timer:start(1000, 0, vim.schedule_wrap(function()
    vim.cmd("hi! link SignColumn LineNr")   --set VertSplit color to black
    vim.cmd("autocmd ColorScheme, VimEnter * highlight! link SignColumn LineNr")

    vim.cmd("hi VertSplit ctermfg=black guifg=black")    --set VertSplit color to black
    vim.cmd("hi StatusLine ctermfg=black guifg=black")   --set HSplit color to black

    vim.cmd(("highlight TelescopePromptBorder guifg=%s"):format("#9a95bf"))
    vim.cmd(("highlight TelescopeResultsBorder guifg=%s"):format("#9a95bf"))
    vim.cmd(("highlight TelescopePreviewBorder guifg=%s"):format("#9a95bf"))
    vim.cmd("highlight IndentBlanklineContextChar guifg=#95c0c0 gui=nocombine")
    vim.cmd("highlight clear WhichKeyDesc")
    vim.cmd("highlight WhichKeyDesc guifg=#98be65")

    local normal = hl_fun.get_highlight_values("Normal")
    local darkbg = hl_fun.brighten(normal.background, -3) -- darken by 10%
    hl_fun.highlight("DarkNormal", {bg = darkbg})
end))


