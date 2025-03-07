local plugins_configure = {}

plugins_configure.plugins_groups = {}
plugins_configure.plugin_configure_root = "configure."
plugins_configure["loaded_plugins"] = {}

if vim.g.feature_groups["default"] == true then
    plugins_configure.plugins_groups["default"] = {
        ["nerd_commenter"] = { enabled = true },    -- for quick comment
        ["better_escape"] = { enabled = false },    -- for quick map jk to <esc>
        ["ultisnips"] = { enabled = true },         -- for snippets
        ["snippets"] = { enabled = true },          -- predefined snippets template
        ["linediff"] = { enabled = true },          -- diff view for two lines
        ["diffview"] = { enabled = true },          -- diff view for git
        ["multiple_cursor"] = { enabled = true },   --  multiple cursor to change multi line in the same time
        ["undotree"] = { enabled = true },          -- record all the change history
        ["repeat"] = { enabled = true },            -- repeat some user defined commond
        ["surround"] = { enabled = true },          -- change, make or delete the surrounding
        ["emacs_commandline"] = { enabled = true }, -- use emacs key binding in commondline
        ["auto_pairs"] = { enabled = true },        -- auto complete pairs
        ["bbye"] = { enabled = true },              -- when you close the buffer the window could be reserve
        ["indent_line"] = { enabled = true },       -- display the indent line
        ["better_fold"] = { enabled = false },      -- display better fold
        ["which_key"] = { enabled = true },         -- key binding suggestion
        ["asynctasks"] = { enabled = true },        -- key binding suggestion
        ["plenary"] = { enabled = true },           -- key binding suggestion
        ["mason"] = { enabled = true },             -- package auto install
        ["mason_install"] = { enabled = true },     -- package auto install
        ["tree_sitter"] = { enabled = true },
        ["quick_fix"] = { enabled = true },         -- better quickfix
        ["popup"] = { enabled = true },
        ["easyjump"] = { enabled = true },
        ["non_latin_input"] = { enabled = false },
        ["boole"] = { enabled = true },
        ["nui"] = { enabled = true },
    }
end

if vim.g.feature_groups["org_my_life"] == true then
    plugins_configure.plugins_groups["org_my_life"] = {
        ["calendar"] = { enabled = false }, -- use the obsidian now
        ["vimwiki"] = { enabled = false },
        ["markdown"] = { enabled = false },
        ["vimtex"] = { enabled = true },
        ["obsidian"] = { enabled = true },
        ["obsidian_bridge"] = { enabled = true },
        ["glow"] = { enabled = true }, -- preview markdown in terminal
        ["markdown_code_edit"] = { enabled = true },
        ["markdown_preview"] = { enabled = true },
        ["present"] = { enabled = false },
        ["nabla"] = { enabled = true },            -- for displya latex formulajbyuki/nabla.nvim
        ["clipboard_images"] = { enabled = true }, -- for displya latex formulajbyuki/nabla.nvim
        ["table_mode"] = { enabled = true },
        ["md_bullets"] = { enabled = false },
        ["org_bullets"] = { enabled = false },
        ["headlines"] = { enabled = true },
        ["orgmode"] = { enabled = false }, -- currently use the obsidian
    }
end

if vim.g.feature_groups["git"] == true then
    plugins_configure.plugins_groups["git"] = {
        ["gitsigns"] = { enabled = true },
        ["statuscol"] = { enabled = true },
        ["fugitive"] = { enabled = true },
        ["neogit"] = { enabled = false },
    }
end

if vim.g.feature_groups["enhance"] == true then
    plugins_configure.plugins_groups["enhance"] = {
        ["chatgpt"] = { enabled = true },
        ["session"] = { enabled = true },
        ["session_auto"] = { enabled = true },
        ["hlslens"] = { enabled = true },
        ["todo_comments"] = { enabled = true },
        ["zen_mode"] = { enabled = true },
        ["firenvim"] = { enabled = false },       -- TODO:嵌入nvim到chrome，比较鸡肋
        ["ts_text_object"] = { enabled = false }, -- map v m is used frequency
        ["ultra_fold"] = { enabled = true },
        ["speed_date"] = { enabled = true },
        ["translate"] = { enabled = true },
        ["notify"] = { enabled = true },
        ["noice"] = { enabled = false },
        ["formatter"] = { enabled = true },
        ["auto_select"] = { enabled = true },
        ["syntax_tree_surfer"] = { enabled = true },
        ["ipython"] = { enabled = false },
        ["jupyter"] = { enabled = true },
        ["jukit"] = { enabled = true },   --for jupyter
        ["neogen"] = { enabled = false }, -- generate annotations
        ["terminal"] = { enabled = true },
        ["remote"] = { enabled = true },
        ["high_str"] = { enabled = false },
        ["colorizer"] = { enabled = true },
        ["colortils"] = { enabled = true },
        ["pretty_print_json"] = { enabled = true },
        ["hjson"] = { enabled = true },
        ["json5"] = { enabled = true },
        ["nvim_tree"] = { enabled = true },
        ["accelerate_jk"] = { enabled = false },
        ["scroll"] = { enabled = true and not vim.g.neovide },
        ["animate"] = { enabled = false }, -- TODO: interesting
    }
end

-- main language
if vim.g.feature_groups["special_for_language"] == true then
    plugins_configure.plugins_groups["special_for_language"] = {
        ["python_fold"] = { enabled = false },
    }
end

if vim.g.feature_groups["debug_adapter"] == true then
    plugins_configure.plugins_groups["debug_adapter"] = {
        ["dap_python"] = { enabled = true },
        ["dap_ui"] = { enabled = true },
    }
end

if vim.g.feature_groups["colorschemes"] == true then
    plugins_configure.plugins_groups["colorschemes"] = {
        ["nord"] = { enabled = true, lazy = true },
        ["gruvbox_material"] = { enabled = true, lazy = true },
        ["rose_pine"] = { enabled = true, lazy = true },
        ["material"] = { enabled = true, lazy = false },
        ["onedark"] = { enabled = true, lazy = true },
        ["onedarkpro"] = { enabled = true, lazy = true },
        ["vscode_theme"] = { enabled = true, lazy = true },
    }
end

if vim.g.feature_groups["beauty_vim"] == true then
    plugins_configure.plugins_groups["beauty_vim"] = {
        ["lualine"] = { enabled = true },
        ["bufferline"] = { enabled = true },
        ["web_devicons"] = { enabled = true },
        ["dashboard"] = { enabled = true and not vim.g.neovide },
        ["specs"] = { enabled = true and not vim.g.neovide },
    }
end

if vim.g.feature_groups["lsp"] then
    plugins_configure.plugins_groups["lsp"] = {
        ["coc"] = { enabled = vim.g.feature_groups.lsp == "coc" },
        ["lsp_config"] = { enabled = vim.g.feature_groups.lsp == "builtin" },
        ["trouble"] = { enabled = vim.g.feature_groups.lsp == "builtin", lazy = true },
        ["glance"] = { enabled = true },
        ["navigator"] = { enabled = true, lazy = true }, -- TODO: this plugin will be useful, but too beta
        ["lsp_signature"] = { enabled = vim.g.feature_groups.lsp == "builtin" },
        ["null_ls"] = { enabled = vim.g.feature_groups.lsp == "builtin" },
        ["nvim_cmp"] = { enabled = vim.g.feature_groups.lsp == "builtin" },
        ["copilot_cmp"] = { enabled = vim.g.feature_groups.lsp == "builtin" },
        ["lsp_status"] = { enabled = vim.g.feature_groups.lsp == "builtin" },
        --['lsp_icon'] = { enabled = vim.g.feature_groups.lsp == 'builtin' }, -- directly setting in nvim_cmp
    }
end

if vim.g.feature_groups["file_and_view"] == true then
    plugins_configure.plugins_groups["file_and_view"] = {
        ["telescope"] = { enabled = true },
        ["ctrlsf"] = { enabled = true },                                        -- search the same token under cursor
        ["spectre"] = { enabled = true },                                       -- search the and replace token by reg exp
        ["vista"] = { enabled = vim.g.feature_groups.lsp == "coc" },            -- only works for coc lsp, tree view
        ["file_symbols"] = { enabled = vim.g.feature_groups.lsp == "builtin" }, -- only works for builtin lsp
        ["aerial"] = { enabled = false },                                       -- TODO: if the file_symbols plugin is not fix the bugs, will change to this plugin
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
        else -- true or string for some special target
            for plugin_name, is_active in pairs(plugins_group) do
                local core = require(plugins_configure.plugin_configure_root .. plugin_name).core
                for key, value in pairs(is_active) do
                    core[key] = value
                end
                if core.enabled == true then
                    plugins_configure.loaded_plugins[plugin_name] = true -- added to loaded_plugins
                    table.insert(plugins, core)                          -- add to
                end
            end
        end
    end
    require("lazy").setup(plugins, {
        git = {
            -- defaults for the `Lazy log` command
            -- log = { "-10" }, -- show the last 10 commits
            log = { "-8" }, -- show commits from the last 3 days
            timeout = 500,  -- kill processes that take more than 2 minutes
            url_format = "https://github.com/%s.git",
            -- lazy.nvim requires git >=2.19.0. If you really want to use lazy with an older version,
            -- then set the below to false. This should work, but is NOT supported and will
            -- increase downloads a lot.
            filter = true,
        },

        lockfile = vim.g.CONFIG .. "/lazy-lock.json", -- lockfile generated after running update.
        dev = {
            -- directory where you store your local plugin projects
            path = vim.g.CONFIG .. "/local_plugins",
            ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
            patterns = {},    -- For example {"folke"}
            fallback = false, -- Fallback to git when local plugin doesn't exist
        },
        ui = {
            border = "rounded", -- rounded, double, single, none
        },
        performance = {
            cache = {
                enabled = true,
            },
            reset_packpath = true,        -- reset the package path to improve startup time
            rtp = {
                reset = true,             -- reset the runtime path to $VIMRUNTIME and your config directory
                ---@type string[]
                paths = { vim.g.CONFIG }, -- add any custom paths here that you want to includes in the rtp
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
    })
end

plugins_configure.create_mapping = function()
    for group_name, plugins_group in pairs(plugins_configure.plugins_groups) do
        if vim.g.feature_groups[group_name] then
            for plugin_name, is_active in pairs(plugins_group) do
                if is_active["enabled"] == true then
                    require(plugins_configure.plugin_configure_root .. plugin_name).mapping()
                end
            end
        end
    end
end
return plugins_configure
