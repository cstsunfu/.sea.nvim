-- special setting
local timer = vim.loop.new_timer()
timer:start(3000, 0, vim.schedule_wrap(function()
    vim.cmd("hi! link SignColumn LineNr")   --set VertSplit color to black
    vim.cmd("autocmd ColorScheme, VimEnter * highlight! link SignColumn LineNr")

    if vim.g.colorscheme ~= 'material' then
        vim.cmd("hi! VertSplit ctermfg=black guifg=black")    --set VertSplit color to black
        vim.cmd("hi! StatusLine ctermfg=black guifg=black")   --set HSplit color to black
    end
    if vim.g.colorscheme == 'nord'  then
        vim.cmd("hi! clear Cursor")   --set HSplit color to black
        vim.cmd("hi! Cursor guibg=#00aaaa")   --set HSplit color to black
    end
    --vim.cmd("highlight nCursor guifg='BrightRed'")
    --vim.cmd("highlight nCursor guifg='BrightRed'")
    --hi VertSplit ctermbg=NONE guibg=string(synIDattr(hlID("Normal"), "bg"))   -- TODO if the above setting not work as espect, maybe these setting will work
    --hi VertSplit ctermbg=NONE guibg=dark
    --hi StatusLine ctermbg=NONE guibg=string(synIDattr(hlID("Normal"), "bg"))
    --hi StatusLine ctermbg=NONE guibg=dark

    --vim.cmd("highlight LspDiagnosticsDefaultError guifg='BrightRed'")
    --vim.fn.sign_define("LspDiagnosticsSignError", {text = " ", texthl = "LspDiagnosticsSignError"})
    --vim.fn.sign_define("LspDiagnosticsSignWarning", {text = " ", texthl = "LspDiagnosticsSignWarning"})
    --vim.fn.sign_define("LspDiagnosticsSignInformation", {text = " ", texthl = "LspDiagnosticsSignInformation"})
    --vim.fn.sign_define("LspDiagnosticsSignHint", {text = "ᐅ ", texthl = "LspDiagnosticsSignHint"})

end))
