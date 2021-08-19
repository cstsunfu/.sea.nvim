local plugin = {}

plugin.core = {
    'akinsho/nvim-bufferline.lua', 
    requires = 'kyazdani42/nvim-web-devicons',
    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        vim.cmd("hi TAGBAR guifg=#009090")
        vim.cmd("hi NERDTREE guifg=#009090")
        vim.cmd('highlight IndentBlanklineChar guifg=#808080 gui=nocombine')
        require('bufferline').setup {
            highlights = {
                indicator_selected = {
                    --guifg = "#ee71ee"
                    guifg = "#51afef"
                }
            },
            options = {
                --numbers = "none" | "ordinal" | "buffer_id" | "both",
                numbers = "ordinal",
                --number_style = "superscript" | "" | { "none", "subscript" }, -- buffer_id at index 1, ordinal at index 2
                number_style = "", -- buffer_id at index 1, ordinal at index 2
                --mappings = true | false,
                mappings = true,
                close_command = "bdelete! %d",       -- can be a string | function, see "Mouse actions"
                right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
                left_mouse_command = "buffer %d",    -- can be a string | function, see "Mouse actions"
                middle_mouse_command = nil,          -- can be a string | function, see "Mouse actions"
                -- NOTE: this plugin is designed with this icon in mind,
                -- and so changing this is NOT recommended, this is intended
                -- as an escape hatch for people who cannot bear it for whatever reason
                indicator_icon = '▎',
                --indicator_icon = '',
                buffer_close_icon = '',
                modified_icon = '●',
                close_icon = '',
                left_trunc_marker = '',
                right_trunc_marker = '',
                --- name_formatter can be used to change the buffer's label in the bufferline.
                --- Please note some names can/will break the
                --- bufferline so use this at your discretion knowing that it has
                --- some limitations that will *NOT* be fixed.
                name_formatter = function(buf)  -- buf contains a "name", "path" and "bufnr"
                    -- remove extension from markdown files for example
                    if buf.name:match('%.md') then
                        return vim.fn.fnamemodify(buf.name, ':t:r')
                    end
                end,

                max_name_length = 18,
                max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
                tab_size = 18,
                --diagnostics = false | "nvim_lsp",
                diagnostics = false,
                diagnostics_indicator = function(count, level, diagnostics_dict, context)
                    return "("..count..")"
                end,
                -- NOTE: this will be called a lot so don't do any heavy processing here
                custom_filter = function(buf_number)
                    -- filter out filetypes you don't want to see
                    if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
                        return true
                    end
                    -- filter out by buffer name
                    if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
                        return true
                    end
                    -- filter out based on arbitrary rules
                    -- e.g. filter out vim wiki buffer from tabline in your work repo
                    if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
                        return true
                    end
                end,
                --offsets = {{filetype = "NvimTree", text = "File Explorer", text_align = "left" | "center" | "right"}},
                offsets = {{filetype = "NvimTree", text = "File Explorer", text_align = "center", highlight = 'TAGBAR'}, {filetype = "vista", text = "Code Navigator", text_align = "center", highlight = 'TAGBAR'}},
                --show_buffer_icons = true | false, -- disable filetype icons for buffers
                show_buffer_icons = true, -- disable filetype icons for buffers
                --show_buffer_close_icons = true | false,
                show_buffer_close_icons = true,
                --show_close_icon = true | false,
                show_close_icon = false,
                --show_tab_indicators = true | false,
                show_tab_indicators = true,
                persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
                -- can also be a table containing 2 custom separators
                -- [focused and unfocused]. eg: { '|', '|' }
                --separator_style = "slant" | "thick" | "thin" | { 'any', 'any' },
                separator_style = "thin",
                --enforce_regular_tabs = false | true,
                enforce_regular_tabs = false,
                --always_show_bufferline = true | false,
                always_show_bufferline = true,
                --sort_by = 'id' | 'extension' | 'relative_directory' | 'directory' | function(buffer_a, buffer_b)
                --sort_by = function(buffer_a, buffer_b)
                    ---- add custom logic
                    --function bool_to_number(value)
                        --if value then
                            --return 1
                        --else
                            --return 0
                        --end
                    --end

                    --return bool_to_number(buffer_a.modified) > bool_to_number(buffer_b.modified)
                --end
            }
        }

    end,
}

plugin.mapping = function()

end

return plugin
