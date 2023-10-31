local plugin = {}

plugin.core = {
    "kevinhwang91/nvim-ufo",
    dependencies = 'kevinhwang91/promise-async',
    init = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded

        local function peekOrHover()
            local winid = require('ufo').peekFoldedLinesUnderCursor()
            local bufnr = vim.api.nvim_win_get_buf(winid)
            local keys = {'a', 'i', 'o', 'A', 'I', 'O', 'gd', 'gr'}
            for _, k in ipairs(keys) do
                -- Add a prefix key to fire `trace` action,
                -- if Neovim is 0.8.0 before, remap yourself
                vim.keymap.set('n', k, '<CR>' .. k, {noremap = false, buffer = bufnr})
            end
        end

        -- virtual fold text handler
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
        -- provider indent method for specific filetypes
        local ftMap = {
            vim = 'indent',
            python = 'indent',
            git = ''
        }
        -- provider selector by chain lsp->treesitter->indent
        ---@param bufnr number
        ---@return Promise
        local function customizeSelector(bufnr)
            local function handleFallbackException(err, providerName)
                if type(err) == 'string' and err:match('UfoFallbackException') then
                    return require('ufo').getFolds(bufnr, providerName)
                else
                    return require('promise').reject(err)
                end
            end

            return require('ufo').getFolds(bufnr, 'lsp'):catch(function(err)
                return handleFallbackException(err, 'treesitter')
            end):catch(function(err)
                return handleFallbackException(err, 'indent')
            end)
        end

        require('ufo').setup({
            open_fold_hl_timeout = 0,
            fold_virt_text_handler = handler,
            provider_selector = function(bufnr, filetype, buftype)
                return ftMap[filetype] or customizeSelector
            end
        })
    end,
}

plugin.mapping = function()

end

return plugin
