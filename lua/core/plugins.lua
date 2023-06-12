local plugins_configure = {}

plugins_configure.plugins_groups = {}
plugins_configure.plugin_configure_root = 'configure.'
plugins_configure["all_loaded_module"] = {}

if vim.g.feature_groups['default'] == true then
    plugins_configure.plugins_groups['default'] = {
        ["nerd_commenter"] = { enable = true }, -- for quick comment
        ["better_escape"] = { enable = false }, -- for quick map jk to <esc>
        ["ultisnips"] = { enable = true }, -- for snippets
        ["snippets"] = { enable = true }, -- predefined snippets templete
        ['linediff'] = { enable = true }, -- diff view for two lines
        ['diffview'] = { enable = true }, -- diff view for git
        ['multiple_cursor'] = { enable = true }, --  multiple cursor to change multi line in the same time
        ['undotree'] = { enable = true }, -- record all the change history
        ['repeat'] = { enable = true }, -- repeat some user defined commond
        ['surround'] = { enable = true }, -- change, make or delete the surrounding
        ['emacs_commandline'] = { enable = true }, -- use emacs key binding in commondline
        ['auto_pairs'] = { enable = true }, -- auto complete pairs
        ['bbye'] = { enable = true }, -- when you close the buffer the window could be reserve
        ['indent_line'] = { enable = true }, -- display the indent line
        ['better_fold'] = { enable = true }, -- display better fold
        ['which_key'] = { enable = true }, -- key binding suggestion
        ['asynctasks'] = { enable = true }, -- key binding suggestion
        ['plenary'] = { enable = true }, -- key binding suggestion
        ['tree_sitter'] = { enable = true },
        ['popup'] = { enable = true },
        ['easyjump'] = { enable = true },
        ['non_latin_input'] = { enable = false },
        ['boole'] = { enable = true },
        ['nui'] = { enable = true },
    }
end


if vim.g.feature_groups['org_my_life'] == true then
    plugins_configure.plugins_groups['org_my_life'] = {
        ['calendar'] = { enable = true },
        ['vimwiki'] = { enable = true },
        ['vimtex'] = { enable = true },
        ['obsidian'] = { enable = true },
        ['glow'] = { enable = true }, -- preview markdown in terminal
        ['markdown_code_edit'] = { enable = true },
        ['markdown_preview'] = { enable = true },
        ['present'] = { enable = true },
        ['nabla'] = { enable = true }, -- for displya latex formulajbyuki/nabla.nvim
        ['clipboard_images'] = { enable = true }, -- for displya latex formulajbyuki/nabla.nvim
        ['table_mode'] = { enable = true },
        ['md_bullets'] = { enable = true },
        ['org_bullets'] = { enable = true },
        ['headlines'] = { enable = false },
        ['orgmode'] = { enable = true },
    }
end

if vim.g.feature_groups['git'] == true then
    plugins_configure.plugins_groups['git'] = {
        ['gitsigns'] = { enable = true },
        ['statuscol'] = { enable = true },
        ['fugitive'] = { enable = true },
    }
end

if vim.g.feature_groups['enhance'] == true then
    plugins_configure.plugins_groups['enhance'] = {
        ['session'] = { enable = true },
        ['session_auto'] = { enable = true },
        ['hlslens'] = { enable = true },
        ['todo_comments'] = { enable = true },
        ['zen_mode'] = { enable = true },
        ['firenvim'] = { enable = false }, -- TODO:嵌入nvim到chrome，比较鸡肋
        ['ts_text_object'] = { enable = false }, -- map v m is used frequence
        ['speed_date'] = { enable = true },
        ['translate'] = { enable = true },
        ['notify'] = { enable = true },
        ['auto_select'] = { enable = true },
        ['ipython'] = { enable = true },
        ['jukit'] = { enable = true }, --for jupyter
        ['neogen'] = { enable = false }, -- generate annotations
        ['terminal'] = { enable = true },
        ['remote'] = { enable = true },
        ['high_str'] = { enable = false },
        ['colorizer'] = { enable = true },
        ['colortils'] = { enable = true },
        ['pretty_print_json'] = { enable = true },
        ['hjson'] = { enable = true },
        ['json5'] = { enable = true },
        ["files_tree"] = { enable = true },
        ["accelerate_jk"] = { enable = false },
        ["scroll"] = { enable = true },
        ["animate"] = { enable = false },  -- TODO: interesting
    }
end

-- main language
if vim.g.feature_groups['special_for_language'] == true then
    plugins_configure.plugins_groups['special_for_language'] = {
        ['python_fold'] = { enable = false },
    }
end

if vim.g.feature_groups['debug_adapter'] == true then
    plugins_configure.plugins_groups['debug_adapter'] = {
        ['dap_python'] = { enable = true },
        ['dap_ui'] = { enable = true }
    }
end

if vim.g.feature_groups['colorschemes'] == true then
    plugins_configure.plugins_groups['colorschemes'] = {
        ["nord"] = { enable = true, lazy = true },
        ['gruvbox_material'] = { enable = true, lazy = true },
        ['rose_pine'] = { enable = true, lazy = true },
        ['material'] = { enable = true, lazy = false },
        ['onedark'] = { enable = true, lazy = true },
        ['onedarkpro'] = { enable = true, lazy = true },
        ['vscode_theme'] = { enable = true, lazy = true }
    }
end


if vim.g.feature_groups['beauty_vim'] == true then
    plugins_configure.plugins_groups['beauty_vim'] = {
        ["lualine"] = { enable = true },
        ["bufferline"] = { enable = true },
        ["web_devicons"] = { enable = true },
        ["dashboard"] = { enable = true },
        ["specs"] = { enable = true },
    }
end


if vim.g.feature_groups['lsp'] then
    plugins_configure.plugins_groups['lsp'] = {
        ['coc'] = { enable = vim.g.feature_groups.lsp == 'coc' },
        ["lsp_config"] = { enable = vim.g.feature_groups.lsp == 'builtin' },
        ["trouble"] = { enable = vim.g.feature_groups.lsp == 'builtin', lazy = true },
        ["glance"] = { enable = true },
        ["navigator"] = { enable = true, lazy = true }, -- TODO: this plugin will be useful, but too beta
        ["lsp_signature"] = { enable = vim.g.feature_groups.lsp == 'builtin' },
        ["null_ls"] = { enable =  vim.g.feature_groups.lsp == 'builtin' },
        ["nvim_cmp"] = { enable = vim.g.feature_groups.lsp == 'builtin' },
        ["copilot"] = { enable = vim.g.feature_groups.lsp == 'builtin' },
        ["copilot_cmp"] = { enable = vim.g.feature_groups.lsp == 'builtin' },
        ["lsp_status"] = { enable = vim.g.feature_groups.lsp == 'builtin' },
        --['lsp_icon'] = { enable = vim.g.feature_groups.lsp == 'builtin' }, -- directly setting in nvim_cmp
        --['fold_expr'] = { enable = vim.g.feature_groups.lsp == 'builtin' }, -- may cause slow
    }
end

if vim.g.feature_groups['file_and_view'] == true then
    plugins_configure.plugins_groups['file_and_view'] = {
        ["telescope"] = { enable = true },
        ['ctrlsf'] = { enable = true }, -- search the same token under cursor
        ['spectre'] = { enable = true }, -- search the and replace token by reg exp
        ["vista"] = { enable = vim.g.feature_groups.lsp == 'coc' }, -- only works for coc lsp, tree view
        ["file_symbols"] = { enable = vim.g.feature_groups.lsp == 'builtin' }, -- only works for builtin lsp
        ["aerial"] = { enable = false }, -- TODO: if the file_symbols plugin is not fix the bugs, will change to this plugin
    }
end

plugins_configure.setup = function()
    local plugins = {}
    for group_name, plugins_group in pairs(plugins_configure.plugins_groups) do
        if vim.g.feature_groups[group_name] == nil then
            vim.notify(group_name .. " is not in vim.g.feature_groups", vim.lsp.log_levels.ERROR, {
                title = "ERROR",
                icon = "",
                timeout = 3000,
            })
        else -- true or string for some special taget
            for plugin_name, is_active in pairs(plugins_group) do
                local core = require(plugins_configure.plugin_configure_root .. plugin_name).core
                for key, value in pairs(is_active) do
                    core[key] = value
                end
                if core.enable == true then
                    plugins_configure.all_loaded_module[plugin_name] = true -- added to all_loaded_module
                    table.insert(plugins, core) -- add to 
                end
            end
        end
    end
    require("lazy").setup(
        plugins,
        {
            git = {
                -- defaults for the `Lazy log` command
                -- log = { "-10" }, -- show the last 10 commits
                log = { "-8" }, -- show commits from the last 3 days
                timeout = 500, -- kill processes that take more than 2 minutes
                url_format = "https://github.com/%s.git",
                -- lazy.nvim requires git >=2.19.0. If you really want to use lazy with an older version,
                -- then set the below to false. This should work, but is NOT supported and will
                -- increase downloads a lot.
                filter = true,
            },
            dev = {
                -- directory where you store your local plugin projects
                path = "~/.sea.nvim/local_plugins",
                ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
                patterns = {}, -- For example {"folke"}
                fallback = false, -- Fallback to git when local plugin doesn't exist
            },
            performance = {
                cache = {
                    enabled = true,
                },
                reset_packpath = true, -- reset the package path to improve startup time
                rtp = {
                    reset = true, -- reset the runtime path to $VIMRUNTIME and your config directory
                    ---@type string[]
                    paths = {vim.g.CONFIG}, -- add any custom paths here that you want to includes in the rtp
                    ---@type string[] list any plugins you want to disable here
                    disabled_plugins = {
                        -- "gzip",
                        -- "matchit",
                        -- "matchparen",
                        -- "netrwPlugin",
                        -- "tarPlugin",
                        -- "tohtml",
                        -- "tutor",
                        -- "zipPlugin",
                    },
                },
            },

        }
    )
end

plugins_configure.create_mapping = function()
    for group_name, plugins_group in pairs(plugins_configure.plugins_groups) do
        if vim.g.feature_groups[group_name] then
            for plugin_name, is_active in pairs(plugins_group) do
                if is_active['enable'] == true then
                    require(plugins_configure.plugin_configure_root .. plugin_name).mapping()
                end
            end
        end
    end
end
return plugins_configure
