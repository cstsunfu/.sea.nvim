vim.cmd [[
    highlight! DiagnosticSignError guibg=None guifg=#ec5f67 gui=bold
    highlight! DiagnosticSignWarn guibg=None guifg=#FF8800 gui=bold
    highlight! DiagnosticSignInfo guibg=None guifg=#008080 gui=bold
    highlight! DiagnosticSignHint guibg=None guifg=#a9a1e1 gui=bold
    highlight! DiagnosticHeader guibg=None guifg=#FF8800 gui=bold

    highlight FloatBorder guifg=#7B68EE guibg=#None
    autocmd! ColorScheme * highlight FloatBorder guifg=#7B68EE guibg=None
]]
    --autocmd! ColorScheme * highlight NormalFloat guifg=#00cccc guibg=None
    --highlight NormalFloat guifg=#00cccc guibg=None
--local border = {
--      {"🭽", "FloatBorder"},
--      {"▔", "FloatBorder"},
--      {"🭾", "FloatBorder"},
--      {"▕", "FloatBorder"},
--      {"🭿", "FloatBorder"},
--      {"▁", "FloatBorder"},
--      {"🭼", "FloatBorder"},
--      {"▏", "FloatBorder"},
--}

local signs = { Error = " ", Warn = "", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    --vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    vim.fn.sign_define(hl, { text = icon, texthl = hl })
end

vim.diagnostic.config({
    signs = true,
    underline = true,
    update_in_insert = true,
    severity_sort = false,
    float = {
        source = "always",  -- Or "if_many"
    },
    virtual_text = false
    --    {
    --    prefix = '  ', -- Could be '●', '▎', 'x'
    --    source = "if_many",  -- Or "if_many"
    --}
})

require('lspconfig.ui.windows').default_options.border = 'rounded'
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
    --border = border,
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    --border = border,
    border = "rounded",
})

function PrintDiagnostics(opts, bufnr, line_nr, client_id)
    bufnr = bufnr or 0
    line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)
    opts = opts or {['lnum'] = line_nr}

    local line_diagnostics = vim.diagnostic.get(bufnr, opts)
    if vim.tbl_isempty(line_diagnostics) then return end

    local diagnostic_message = ""
    for i, diagnostic in ipairs(line_diagnostics) do
        diagnostic_message = diagnostic_message .. string.format("%d: %s", i, diagnostic.message or "")
        print(diagnostic_message)
        if i ~= #line_diagnostics then
            diagnostic_message = diagnostic_message .. "\n"
        end
    end
    vim.api.nvim_echo({{diagnostic_message, "Normal"}}, false, {})
end

--vim.cmd [[ autocmd! CursorHold * lua PrintDiagnostics() ]]
_G.diag_format = function(diagnostic)
    if diagnostic.severity == vim.diagnostic.severity.ERROR then
        return string.format("%s", diagnostic.message)
    end
    return diagnostic.message
end

vim.cmd [[autocmd! CursorHold * lua vim.diagnostic.open_float(nil, {focus=false, border = "rounded", format=_G.diag_format, header = { " Diagnostics", "DiagnosticHeader"} })]]
    

