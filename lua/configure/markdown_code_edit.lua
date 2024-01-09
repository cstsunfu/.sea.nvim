local plugin = {}

plugin.core = {
    "Chandlercjy/vim-markdown-edit-code-block",

    init = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        vim.api.nvim_create_autocmd({ "BufEnter" }, {
            callback = function()
                -- set the filetype to python.markdown
                vim.bo.filetype = "python.markdown"
            end,
            pattern = "*.ju.py",
        })
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
    _G._edit_code_block = function()
        local filetype = vim.bo.filetype
        if filetype == "python.markdown" then
            -- get current line number
            local start_line = vim.fn.line(".")
            -- if current line is not startwith "# %%", then
            -- find the line previous to the current line that start with "# %%"
            if vim.fn.getline(start_line):match("# %%") == nil then
                start_line = vim.fn.search("# %%", "zbn")
            end
            -- if the start line is startwith string "# %% [md]" or "# %% [markdown]" then edit the block
            if start_line ~= 0 then
                local line = vim.fn.getline(start_line)
                if line:match("# %%%% %[(.*)%]") ~= "md" and line:match("# %%%% %[(.*)%]") ~= "markdown" then
                    return
                end
            end
            local end_line = vim.fn.search("# %%", "zenW")
            if end_line == 0 then
                end_line = vim.fn.line("$")
            end
            if end_line - start_line < 2 then
                -- buffer append empty lines
                local buffer = vim.api.nvim_get_current_buf()
                for _ = 1, 2 - (end_line - start_line) do
                    vim.api.nvim_buf_set_lines(buffer, end_line, end_line, false, { "" })
                end
                end_line = vim.fn.line("$")
            end
            start_line = start_line + 1
            vim.cmd(start_line .. "," .. end_line .. "MarkdownEditBlock")
        else
            vim.cmd("MarkdownEditBlock")
        end
    end
    mappings.register({
        mode = "n",
        key = { "<leader>", "c", "e" },
        action = ":lua _G._edit_code_block()<CR>",
        short_desc = "Code Edit",
        silent = true,
    })
end

return plugin
