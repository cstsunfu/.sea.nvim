local plugin = {}

plugin.core = {
    "kevinhwang91/nvim-ufo",
    dependencies = 'kevinhwang91/promise-async',
    init = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        local handler = function(virtText, lnum, endLnum, width, truncate)
            local newVirtText = {}
            local suffix = (' %d '):format(endLnum - lnum)
            local sufWidth = vim.fn.strdisplaywidth(suffix)
            local targetWidth = width - sufWidth
            local curWidth = 0
            for _, chunk in ipairs(virtText) do
                local chunkText = chunk[1]
                local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                if targetWidth > curWidth + chunkWidth then
                    table.insert(newVirtText, chunk)
                else
                    chunkText = truncate(chunkText, targetWidth - curWidth)
                    local hlGroup = chunk[2]
                    table.insert(newVirtText, {chunkText, hlGroup})
                    chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    -- str width returned from truncate() may less than 2nd argument, need padding
                    if curWidth + chunkWidth < targetWidth then
                        suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                    end
                    break
                end
                curWidth = curWidth + chunkWidth
            end
            table.insert(newVirtText, {suffix, 'MoreMsg'})
            return newVirtText
        end
        local ftMap = {
            vim = 'indent',
            python = {'indent'},
            git = ''
        }

        -- global handler
        -- `handler` is the 2nd parameter of `setFoldVirtTextHandler`,
        -- check out `./lua/ufo.lua` and search `setFoldVirtTextHandler` for detail.
        require('ufo').setup({
            fold_virt_text_handler = handler,
            open_fold_hl_timeout = 150,
            provider_selector = function(bufnr, filetype, buftype)
                -- if you prefer treesitter provider rather than lsp,
                -- return ftMap[filetype] or {'treesitter', 'indent'}
                return ftMap[filetype]
            end
        })
    end,
}

plugin.mapping = function()

end

return plugin
