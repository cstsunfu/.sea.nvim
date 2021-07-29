local plugins_configure = {}
plugins_configure.plugins_groups = {}
--let g:vimwiki_map_prefix='<leader>o'
plugins_configure.plugin_configure_root = 'configure.'
plugins_configure["all_loaded_module"] = {}

plugins_configure.plugins_groups['default'] = {
    ["nerd_commenter"] = {disable=false},       -- for quick comment
    ["ultisnips"] = {disable=false},            -- for snippets
    ["snippets"] = {disable=false},             -- predefined snippets templete
    ['linediff'] = {disable=false},             -- diff view for two lines
    ['ctrlsf'] = {disable=false},               -- search the same token under cursor
    ['multiple_cursor'] = {disable=false},      --  multiple cursor to change multi line in the same time
    ['undotree'] = {disable=false},             -- record all the change history
    ['repeat'] = {disable=false},               -- repeat some user defined commond
    ['surround'] = {disable=false},             -- change, make or delete the surrounding
    ['emacs_commandline'] = {disable=false},    -- use emacs key binding in commondline
    ['auto_pairs'] = {disable=false},           -- auto complete pairs
    ['bbye'] = {disable=false},                 -- when you close the buffer the window could be reserve
    ['indent_line'] = {disable=false},          -- display the indent line
    ['better_fold'] = {disable=false},          -- display better fold
    ['which_key'] = {disable=false, opt=false}             -- key binding suggestion
}

plugins_configure.plugins_groups['complete'] = {
    ["lsp_config"] = {disable=false},
    ["nvim_comp"] = {disable=false},
    ['lsp_icon'] = {disable=false},
    ['lsp_installer'] = {disable=false},
    ['tree_sitter'] = {disable=false},
    ['fold_expr'] = {disable=false}
}

plugins_configure.plugins_groups['colorschemes'] = {
    ["nord"] = {disable=false, opt=true},
    ["github_nvim_theme"] = {disable=false, opt=true},
    ['gruvbox_material'] = {disable=false, opt=true}
}


plugins_configure.plugins_groups['beauty_vim'] = {
    ["lualine"] = {disable=false},
    ["bufferline"] = {disable=false},
}

plugins_configure.plugins_groups['file_and_view'] = {
    ["telescope"] = {disable=false},
    ["files_tree"] = {disable=false},
    ["file_symbols"] = {disable=false},
    ["navigator"] = {disable=true},     -- TODO, this plugin will be useful, but too beta
}

plugins_configure.plugins_groups['move_behavior'] = {
    ["accelerate_jk"] = {disable=false},
    ["scroll"] = {disable=false},
}

plugins_configure.setup = function()
    packer.startup(function()
        for group_name, plugins_group in pairs(plugins_configure.plugins_groups) do
            if feature_groups[group_name] == nil then
                print(group_name.." is not in feature_groups")
            elseif feature_groups[group_name] == true then
                for plugin_name, is_active in pairs(plugins_group) do
                    core = require(plugins_configure.plugin_configure_root..plugin_name).core
                    for key, value in pairs(is_active) do
                        core[key] = value
                    end
                    if core.disable == false then
                        plugins_configure.all_loaded_module[plugin_name] = true-- added to all_loaded_module
                    end
                    use(core)
                    --print(core[1]..' is loaded')
                end
            end
        end
    end
    )
end

plugins_configure.create_mapping = function()
    for group_name, plugins_group in pairs(plugins_configure.plugins_groups) do
        --print(group_name)
        if feature_groups[group_name] == true then
            for plugin_name, is_active in pairs(plugins_group) do
                if is_active['disable'] == false then
                    --print(plugin_name)
                    require(plugins_configure.plugin_configure_root..plugin_name).mapping()
                end
            end
        end
    end
end
return plugins_configure
