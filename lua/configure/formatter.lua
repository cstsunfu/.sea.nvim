local plugin = {}

plugin.core = {
    "mhartington/formatter.nvim",
    init = function() -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        -- Utilities for creating configurations
        local util = require "formatter.util"
        local filetype = {
            python = {
                function()
                    return{
                        exe = "yapf",
                        stdin = true,
                    }
                end
            },
            sql = {
                require("formatter.filetypes.sql").pgformat,
            },
        }
        -- Create a list of filetypes
        local _format_filetypes = {}
        for k, _ in pairs(filetype) do
            table.insert(_format_filetypes, k)
        end
        vim.g._format_filetypes = _format_filetypes
        -- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
        require("formatter").setup {
            -- Enable or disable logging
            logging = false,
            -- Set the log level
            log_level = vim.log.levels.WARN,
            -- All formatter configurations are opt-in
            filetype = filetype,
        }

    end,
}

plugin.mapping = function()

    local mappings = require('core.mapping')

    function _G._auto_format(visual)
        local filetype = vim.bo.filetype
        -- if filetype in vim.g._format_filetypes
        if vim.tbl_contains(vim.g._format_filetypes, filetype) then
            vim.cmd("Format")
        else
            vim.cmd("lua vim.lsp.buf.format()")
        end
    end
    mappings.register({
        mode = {"v", 'x', 'n'},
        key = { '<leader>', '=' },
        action = ":lua _G._auto_format()<cr>",
        short_desc = "Auto Format"
    })
end

return plugin
