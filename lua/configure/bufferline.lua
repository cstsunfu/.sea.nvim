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
                numbers = function(opts)
                  return string.format('%s.', opts.ordinal)
                end,
                --number_style = "superscript" | "" | { "none", "subscript" }, -- buffer_id at index 1, ordinal at index 2
                --mappings = true | false,
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
                --sort_by = 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
                --sort_by = function(buffer_a, buffer_b)
                    ---- add custom logic
                    --local function bool_to_number(value, id)
                        --if value then
                            --return 100000 - id
                        --else
                            --return 0 - id
                        --end
                    --end

                    --return bool_to_number(buffer_a.modified, buffer_a.ordinal) > bool_to_number(buffer_b.modified, buffer_b.ordinal)
                --end
            }
        }


    end,
}

plugin.mapping = function()
    local mappings = require('core.mapping')
    for i=1,9,1 do
        mappings.register({
            mode = "n",
            key = {"<leader>", tostring(i)},
            action = "<Cmd>BufferLineGoToBuffer ".. tostring(i)..'<cr>',
            short_desc = "Goto "..tostring(i).." Buffer",
            noremap = true,
            silent = true,
        })
    end
    mappings.register({
        mode = "n",
        key = {"<leader>", "b", "n"},
        action = "<Cmd>BufferLineCycleNext<cr>",
        short_desc = "Goto Next Buffer",
        noremap = true,
        silent = true,
    })
    mappings.register({
        mode = "n",
        key = {"<leader>", "b", "p"},
        action = "<Cmd>BufferLineCyclePrev<cr>",
        short_desc = "Goto Prev Buffer",
        noremap = true,
        silent = true,
    })
    mappings.register({
        mode = "n",
        key = {"<leader>", "b", "d"},
        action = ":bdelete<cr>",
        short_desc = "Delete Current Buffer"
    })


    mappings.register({
        mode = "n",
        key = {"<leader>", "b", "D"},
        action = ":lua require('util.global').delete_all_buffers_in_window()<cr>",
        short_desc = "Delete All Buffer Except Current"
    })
    _G.buffer_sort_by_whether_modified = function(buffer_a, buffer_b)
        -- add custom logic
        local function bool_to_number(value, id)
            if value then
                return 100000 - id
            else
                return 0 - id
            end
        end

        return bool_to_number(buffer_a.modified, buffer_a.ordinal) > bool_to_number(buffer_b.modified, buffer_b.ordinal)
    end

    mappings.register({
        mode = "n",
        key = {"<leader>", "b", "s"},
        action = ":lua require'bufferline'.sort_buffers_by(_G.buffer_sort_by_whether_modified)<cr>",
        short_desc = "Buffer Sorted By Whether Modified"
    })
end

return plugin
