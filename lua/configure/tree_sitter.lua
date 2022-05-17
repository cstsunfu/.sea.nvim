local plugin = {}

plugin.core = {
    "nvim-treesitter/nvim-treesitter",
    --as = "nvim-treesitter",
    run = ':TSUpdate',

    setup = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded
        require'nvim-treesitter.configs'.setup {
            ensure_installed = {
                "bash",
                "bibtex",
                "c",
                "cmake",
                "comment",
                "cpp",
                "css",
                "dockerfile",
                "go",
                "hjson",
                "html",
                "java",
                "javascript",
                "json",
                "json5",
                "jsonc",
                "julia",
                "latex",
                "lua",
                "llvm",
                "make",
                "norg",
                "org",
                "perl",
                "python",
                "regex",
                "rust",
                "scheme",
                "scss",
                "toml",
                "typescript",
                "vim",
                "vue",
                "yaml",
                "yaml",
            }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
            ignore_install = {
            }, -- List of parsers to ignore installing
            highlight = {
                enable = true,              -- false will disable the whole extension
                disable = {'org'},  -- list of language that will be disabled
                additional_vim_regex_highlighting = {'org'}, -- Required since TS highlighter doesn't support all syntax features (conceal)
                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
            },
            indent = {
                enable = false, -- enable when this is stable
            }
        }
    end,
}

plugin.mapping = function()

end

return plugin
