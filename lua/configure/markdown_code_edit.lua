local plugin = {}

plugin.core = {
    "Chandlercjy/vim-markdown-edit-code-block",
    ft = { "markdown", "python.markdown" },
    init = function() -- Specifies code to run before this plugin is loaded.
        vim.api.nvim_create_autocmd({ "BufEnter" }, {
            callback = function()
                -- set the filetype to python.markdown
                vim.bo.filetype = "python.markdown"
            end,
            pattern = "*.ju.py",
        })
    end,

    config = function() -- Specifies code to run after this plugin is loaded
    end,
}

plugin.mapping = function()
    local mappings = require("core.mapping")
    _G._edit_code_block = function()
        local filetype = vim.bo.filetype
        if filetype == "python.markdown" then
            -- get current line number
            local current_line = vim.fn.line(".")
            -- find the line previous to the current line that start with "# %%"
            local start_line = 0
            if vim.fn.getline(current_line):match("# %%") then
                start_line = current_line
            else
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
            else
                end_line = end_line - 1
            end
            local quote = [["""]]
            local blank = [[]]
            local first_unblank_quote_line = nil
            local last_unblank_quote_line = nil
            for i = start_line + 1, end_line do
                local line = vim.fn.getline(i)
                -- if line is not blank line
                if line:match("^%s*$") == nil then
                    -- if line is start with `quote`
                    if line:match("^" .. quote) ~= nil then
                        first_unblank_quote_line = i
                    end
                    break
                end
            end
            for i = end_line, start_line, -1 do
                local line = vim.fn.getline(i)
                -- if line is not blank line
                if line:match("^%s*$") == nil then
                    -- if line is not start with `quote`
                    if line:match("^" .. quote) ~= nil then
                        last_unblank_quote_line = i
                    end
                    break
                end
            end
            if first_unblank_quote_line ~= nil and last_unblank_quote_line ~= nil then
                start_line = first_unblank_quote_line
                end_line = last_unblank_quote_line - 1
            end
            local need_blank = 2 - (end_line - start_line)
            if need_blank < 0 then
                need_blank = 0
            end
            for i = 1, need_blank do
                vim.api.nvim_buf_set_lines(0, start_line, start_line, false, { blank })
            end
            start_line = start_line + 1
            end_line = end_line + need_blank

            vim.cmd(start_line .. "," .. end_line .. "MarkdownEditBlock")
        elseif filetype == "markdown" then
            vim.cmd("MarkdownEditBlock")
        else
            vim.print("Only markdown and ju.py file can be edit code block")
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
