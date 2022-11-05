local plugin = {}

plugin.core = {
    "ekickx/clipboard-image.nvim",
    setup = function() -- Specifies code to run before this plugin is loaded.
    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require 'clipboard-image'.setup {
            -- Default configuration for all filetype
            default = {
                img_dir = "img",
                img_dir_txt = "img",
                img_name = function()
                    --return os.date('%Y-%m-%d-%H-%M-%S')

                    return vim.fn.input('Image Name: ', '') .. os.date("-%Y_%m_%d")
                end, -- Example result: "2021-04-13-10-04-18"
                affix = "![](%s)"
            },
            -- You can create configuration for ceartain filetype by creating another field (markdown, in this case)
            -- If you're uncertain what to name your field to, you can run `lua print(vim.bo.filetype)`
            -- Missing options from `markdown` field will be replaced by options from `default` field
            -- markdown = {
            -- }
        }
    end,
}

plugin.mapping = function()
    local mappings = require('core.mapping')
    _G.clipeboard_paste_image = function()
        local file_path = vim.fn.expand('%:p:h', nil, nil)
        local i, j = string.find(file_path, "MyKB")
        if j ~= nil then
            local mykb = string.sub(file_path, 0, j)
            require("clipboard-image.paste").paste_img({
                img_dir = {mykb, "Files"},

                img_dir_txt = "Files",
                img_name = function()
                    vim.g._obsidian_temp_image_name = os.date("%Y-%m-%d_%H_%M_") .. vim.fn.input('Image Name: ', '')
                    return vim.g._obsidian_temp_image_name
                end, -- Example result: "2021-04-13-10-04-18"
                affix = "![](%s)"
                --affix = function()
                --    return "![](Files/"..vim.g._obsidian_temp_image_name..")"
                --end
            })
        else
            require("clipboard-image.paste").paste_img()  -- default
        end
    end
    mappings.register({
        mode = "n",
        key = { "<localleader>", 'p' },
        action = ":lua _G.clipeboard_paste_image()<cr>",
        short_desc = "Paste Image"
    })
end

return plugin
