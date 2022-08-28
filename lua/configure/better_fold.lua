local plugin = {}

plugin.core = {
    "scr1pt0r/crease.vim",
    as = "crease",
    --requires = {{'airblade/vim-gitgutter'}},
    setup = function()  -- Specifies code to run before this plugin is loaded.
        --vim.o.foldcolumn = 0
        --vim.o.foldlevelstart = 0
        --" 'space' is fold char ↓

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        --vim.g.crease_foldtext = { default = " %l lines %f%f%t%=%{gitgutter#fold#is_changed() ? ' ' : ''}%=" }
        vim.g.crease_foldtext = { 
            --default = "  %l lines %f%f  %t%= ",
            indent = '%{repeat(" ", shiftwidth() * v:foldlevel)}➤ %l lines %f%f %t %f'
        }
    end,

}
--plugin.core = {
--    "kevinhwang91/nvim-ufo",
--    requires = 'kevinhwang91/promise-async',
--    setup = function()  -- Specifies code to run before this plugin is loaded.
--    end,

--    config = function() -- Specifies code to run after this plugin is loaded
--        vim.wo.foldcolumn = '1'
--        vim.wo.foldlevel = 99 -- feel free to decrease the value
--        vim.wo.foldenable = true
--        if vim.g.feature_groups.lsp == 'builtin' then
--            local capabilities = vim.lsp.protocol.make_client_capabilities()
--            capabilities.textDocument.foldingRange = {
--                dynamicRegistration = false,
--                lineFoldingOnly = true
--            }
--        end
--        local handler = function(virtText, lnum, endLnum, width, truncate)
--            local newVirtText = {}
--            local suffix = ('  %d '):format(endLnum - lnum)
--            local sufWidth = vim.fn.strdisplaywidth(suffix)
--            local targetWidth = width - sufWidth
--            local curWidth = 0
--            for _, chunk in ipairs(virtText) do
--                local chunkText = chunk[1]
--                local chunkWidth = vim.fn.strdisplaywidth(chunkText)
--                if targetWidth > curWidth + chunkWidth then
--                    table.insert(newVirtText, chunk)
--                else
--                    chunkText = truncate(chunkText, targetWidth - curWidth)
--                    local hlGroup = chunk[2]
--                    table.insert(newVirtText, {chunkText, hlGroup})
--                    chunkWidth = vim.fn.strdisplaywidth(chunkText)
--                    -- str width returned from truncate() may less than 2nd argument, need padding
--                    if curWidth + chunkWidth < targetWidth then
--                        suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
--                    end
--                    break
--                end
--                curWidth = curWidth + chunkWidth
--            end
--            table.insert(newVirtText, {suffix, 'MoreMsg'})
--            return newVirtText
--        end
--        require('ufo').setup(
--            {fold_virt_text_handler = handler}
--        )
--        -- buffer scope handler
--        -- will override global handler if it is existed
--        local bufnr = vim.api.nvim_get_current_buf()
--        require('ufo').setVirtTextHandler(bufnr, handler)
--    end,

--}

plugin.mapping = function()

end
return plugin
