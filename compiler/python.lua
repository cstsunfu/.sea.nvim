-- Help: https://vimhelp.org/usr_41.txt.html#write-compiler-plugin
-- Credit: https://vi.stackexchange.com/questions/5110/quickfix-support-for-python-tracebacks
if vim.g.current_compiler then
    return
end
vim.g.current_compiler = "python"

-- Keep each traceback frame as a valid quickfix entry. Source lines, carets,
-- exception messages and AsyncRun status lines remain visible as context.
vim.opt_local.errorformat = {
    [[  File "%f"\, line %l\, in %m]],
    [[  File "%f"\, line %l]],
}

-- %:S shell-escapes the filename, including paths that contain spaces.
vim.opt_local.makeprg = "python3 %:S"
