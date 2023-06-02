local plugin = {}

plugin.core = {
    "jupyter-vim/jupyter-vim",
    ft = { "python" },
    cmd = { "JupyterConnect" },
    init = function() -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
    end,
}

plugin.mapping = function()

    local mappings = require('core.mapping')
    mappings.register({
        mode = "n",
        key = { "<leader>", "j", "r" },
        action = ':!jupyter qtconsole&<cr>',
        short_desc = "Jupyter Run",
        silent = true
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "j", "." },
        action = ':JupyterCd %:p:h<CR>',
        short_desc = "Jupyter Change Dir to Current",
        silent = true
    })
    mappings.register({
        mode = "n",
        key = { "<leader>", "j", "c" },
        action = ':JupyterConnect<CR>',
        short_desc = "Jupyter Connect",
        silent = true
    })
    mappings.register({
        mode = "n",
        key = { "<localleader>", "j", 'e' },
        action = '<Plug>JupyterRunVisual',
        short_desc = "Jupyter Run Visual",
        silent = true
    })
    mappings.register({
        mode = "v",
        key = { "<localleader>", "e" },
        action = ':JupyterRunVisual<cr>',
        short_desc = "Jupyter Run Visual",
        silent = true
    })
    --" Run current file
    --nnoremap <buffer> <silent> <localleader>R :JupyterRunFile<CR>
    --nnoremap <buffer> <silent> <localleader>I :PythonImportThisFile<CR>

    --" Change to directory of current file
    --nnoremap <buffer> <silent> <localleader>d :JupyterCd %:p:h<CR>

    --" Send a selection of lines
    --nnoremap <buffer> <silent> <localleader>X :JupyterSendCell<CR>
    --nnoremap <buffer> <silent> <localleader>E :JupyterSendRange<CR>
    --nmap     <buffer> <silent> <localleader>e <Plug>JupyterRunTextObj
    --vmap     <buffer> <silent> <localleader>e <Plug>JupyterRunVisual

    --nnoremap <buffer> <silent> <localleader>U :JupyterUpdateShell<CR>

    --" Debugging maps
    --nnoremap <buffer> <silent> <localleader>b :PythonSetBreak<CR>
end

return plugin
