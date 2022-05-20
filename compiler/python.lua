-- Help: https://vimhelp.org/usr_41.txt.html#write-compiler-plugin
-- Credit: https://vi.stackexchange.com/questions/5110/quickfix-support-for-python-tracebacks
if vim.g.custom_python_compiler then
    return
end
vim.g.custom_python_compiler = true

vim.cmd[[
    let s:cpo_save = &cpo
    set cpo&vim

    CompilerSet errorformat=
          \%*\\sFile\ \"%f\"\\,\ line\ %l\\,\ %m,
          \%*\\sFile\ \"%f\"\\,\ line\ %l,
    CompilerSet makeprg=python3\ %

    let &cpo = s:cpo_save
    unlet s:cpo_save
]]
