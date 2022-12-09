local plugins_configure = {}

plugins_configure.plugins_groups = {}
plugins_configure.plugin_configure_root = 'configure.'
plugins_configure["all_loaded_module"] = {}

if vim.g.feature_groups['default'] == true then
    plugins_configure.plugins_groups['default'] = {
        ["nerd_commenter"] = { disable = false }, -- for quick comment
        ["better_escape"] = { disable = true }, -- for quick map jk to <esc>
        ["ultisnips"] = { disable = false }, -- for snippets
        ["snippets"] = { disable = false }, -- predefined snippets templete
        ['linediff'] = { disable = false }, -- diff view for two lines
        ['diffview'] = { disable = false }, -- diff view for git
        ['multiple_cursor'] = { disable = false }, --  multiple cursor to change multi line in the same time
        ['undotree'] = { disable = false }, -- record all the change history
        ['repeat'] = { disable = false }, -- repeat some user defined commond
        ['surround'] = { disable = false }, -- change, make or delete the surrounding
        ['emacs_commandline'] = { disable = false }, -- use emacs key binding in commondline
        ['auto_pairs'] = { disable = false }, -- auto complete pairs
        ['bbye'] = { disable = false }, -- when you close the buffer the window could be reserve
        ['indent_line'] = { disable = false }, -- display the indent line
        ['better_fold'] = { disable = false }, -- display better fold
        ['which_key'] = { disable = false, opt = false }, -- key binding suggestion
        ['asynctasks'] = { disable = false }, -- key binding suggestion
        ['plenary'] = { disable = false }, -- key binding suggestion
        ['tree_sitter'] = { disable = false },
        ['popup'] = { disable = false },
        ['easyjump'] = { disable = false },
        ['non_latin_input'] = { disable = true },
        ['boole'] = { disable = false },
    }
end


if vim.g.feature_groups['org_my_life'] == true then
    plugins_configure.plugins_groups['org_my_life'] = {
        ['calendar'] = { disable = false },
        ['vimwiki'] = { disable = false },
        ['vimtex'] = { disable = false },
        ['obsidian'] = { disable = false },
        ['glow'] = { disable = false }, -- preview markdown in terminal
        ['markdown_code_edit'] = { disable = false },
        ['markdown_preview'] = { disable = false },
        ['present'] = { disable = false },
        ['nabla'] = { disable = false }, -- for displya latex formulajbyuki/nabla.nvim
        ['clipboard_images'] = { disable = false }, -- for displya latex formulajbyuki/nabla.nvim
        ['table_mode'] = { disable = false },
        ['md_bullets'] = { disable = false },
        ['org_bullets'] = { disable = false },
        ['headlines'] = { disable = true },
        ['orgmode'] = { disable = false },
    }
end

if vim.g.feature_groups['git'] == true then
    plugins_configure.plugins_groups['git'] = {
        ['gitsigns'] = { disable = false },
        ['fugitive'] = { disable = false },
    }
end

if vim.g.feature_groups['enhance'] == true then
    plugins_configure.plugins_groups['enhance'] = {
        ['hlslens'] = { disable = false },
        ['todo_comments'] = { disable = false },
        ['zen_mode'] = { disable = false },
        ['firenvim'] = { disable = true }, -- TODO:嵌入nvim到chrome，比较鸡肋
        ['ts_text_object'] = { disable = true }, -- map v m is used frequence
        ['speed_date'] = { disable = false },
        ['translate'] = { disable = false },
        ['notify'] = { disable = false },
        ['auto_select'] = { disable = false },
        ['ipython'] = { disable = false },
        ['jukit'] = { disable = false }, --for jupyter
        ['neogen'] = { disable = true }, -- generate annotations
        ['terminal'] = { disable = false },
        ['remote'] = { disable = false },
        ['high_str'] = { disable = true },
        ['colorizer'] = { disable = false },
        ['pretty_print_json'] = { disable = false },
        ['hjson'] = { disable = false },
        ['json5'] = { disable = false },
        ["files_tree"] = { disable = false },
        ["accelerate_jk"] = { disable = true },
        ["scroll"] = { disable = false },
    }
end

-- main language
if vim.g.feature_groups['special_for_language'] == true then
    plugins_configure.plugins_groups['special_for_language'] = {
        ['python_fold'] = { disable = true },
    }
end

if vim.g.feature_groups['debug_adapter'] == true then
    plugins_configure.plugins_groups['debug_adapter'] = {
        ['dap_python'] = { disable = false },
        ['dap_ui'] = { disable = false }
    }
end

if vim.g.feature_groups['colorschemes'] == true then
    plugins_configure.plugins_groups['colorschemes'] = {
        ["nord"] = { disable = false, opt = true },
        ['gruvbox_material'] = { disable = false, opt = true },
        ['rose_pine'] = { disable = false, opt = true },
        ['material'] = { disable = false, opt = true },
        ['onedark'] = { disable = false, opt = true },
        ['onedarkpro'] = { disable = false, opt = true },
        ['vscode_theme'] = { disable = false, opt = true }
    }
end


if vim.g.feature_groups['beauty_vim'] == true then
    plugins_configure.plugins_groups['beauty_vim'] = {
        ["lualine"] = { disable = false },
        ["bufferline"] = { disable = false },
        ["web_devicons"] = { disable = false },
        ["dashboard"] = { disable = false },
        ["specs"] = { disable = false },
    }
end


if vim.g.feature_groups['lsp'] then
    plugins_configure.plugins_groups['lsp'] = {
        ['coc'] = { disable = vim.g.feature_groups.lsp ~= 'coc' },
        ["lsp_config"] = { disable = vim.g.feature_groups.lsp ~= 'builtin' },
        ["trouble"] = { disable = vim.g.feature_groups.lsp ~= 'builtin' },
        ["glance"] = { disable = vim.g.feature_groups.lsp ~= 'builtin' },
        ["null_ls"] = { disable =  vim.g.feature_groups.lsp ~= 'builtin' },
        ["nvim_cmp"] = { disable = vim.g.feature_groups.lsp ~= 'builtin' },
        --['lsp_icon'] = { disable = vim.g.feature_groups.lsp ~= 'builtin' }, -- directly setting in nvim_cmp
        --['fold_expr'] = { disable = vim.g.feature_groups.lsp ~= 'builtin' }, -- may cause slow
    }
end

if vim.g.feature_groups['file_and_view'] == true then
    plugins_configure.plugins_groups['file_and_view'] = {
        ["telescope"] = { disable = false },
        ["navigator"] = { disable = true }, -- TODO: this plugin will be useful, but too beta
        ['ctrlsf'] = { disable = false }, -- search the same token under cursor
        ['spectre'] = { disable = false }, -- search the and replace token by reg exp
        ["vista"] = { disable = vim.g.feature_groups.lsp ~= 'coc' }, -- only works for coc lsp, tree view
        ["file_symbols"] = { disable = vim.g.feature_groups.lsp ~= 'builtin' }, -- only works for builtin lsp
        ["aerial"] = { disable = true }, -- TODO: if the file_symbols plugin is not fix the bugs, will change to this plugin
    }
end

plugins_configure.setup = function()
    packer.startup(function()
        for group_name, plugins_group in pairs(plugins_configure.plugins_groups) do
            if vim.g.feature_groups[group_name] == nil then
                vim.notify(group_name .. " is not in vim.g.feature_groups", vim.lsp.log_levels.ERROR, {
                    title = "ERROR",
                    icon = "",
                    timeout = 3000,
                })
            elseif vim.g.feature_groups[group_name] then -- true or string for some special taget
                for plugin_name, is_active in pairs(plugins_group) do
                    local core = require(plugins_configure.plugin_configure_root .. plugin_name).core
                    for key, value in pairs(is_active) do
                        core[key] = value
                    end
                    if core.disable == false then
                        plugins_configure.all_loaded_module[plugin_name] = true -- added to all_loaded_module
                    end
                    use(core)
                end
            end
        end
    end
    )
end

plugins_configure.create_mapping = function()
    for group_name, plugins_group in pairs(plugins_configure.plugins_groups) do
        if vim.g.feature_groups[group_name] then
            for plugin_name, is_active in pairs(plugins_group) do
                if is_active['disable'] == false then
                    require(plugins_configure.plugin_configure_root .. plugin_name).mapping()
                end
            end
        end
    end
end
return plugins_configure
