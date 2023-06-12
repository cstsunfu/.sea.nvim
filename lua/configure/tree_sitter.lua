local plugin = {}

plugin.core = {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { { 'HiPhish/nvim-ts-rainbow2' } },
    build = ':TSUpdate',

    init = function()  -- Specifies code to run before this plugin is loaded.

    end,

    config = function() -- Specifies code to run after this plugin is loaded

        local rainbow = require 'ts-rainbow'
        require'nvim-treesitter.configs'.setup {
            rainbow = {  -- for rainbow pair
                enable = false,
                disable = {}, -- disable filetype
                query = {
                    'rainbow-parens'
                },
                strategy = rainbow.strategy.global,
                hlgroups = {
                    'TSRainbowGreen',
                    'TSRainbowRed',
                    'TSRainbowViolet',
                    'TSRainbowOrange',
                    'TSRainbowYellow',
                    'TSRainbowCyan',
                    'TSRainbowBlue',
                },
            },
            ensure_installed = {
                "bash",
                "bibtex",
                "c",
                "cmake",
                "cpp",
                "css",
                "dockerfile",
                "go",
                "hjson",
                "markdown",
                "markdown_inline",
                "html",
                "java",
                "javascript",
                "json",
                "json5",
                "jsonc",
                "latex",
                "lua",
                "make",
                "org",
                "perl",
                "python",
                "rust",
                "scheme",
                "scss",
                "toml",
                "vim",
                "yaml",
            }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
            ignore_install = {
            }, -- List of parsers to ignore installing
            highlight = {
                enable = true,              -- false will disable the whole extension
                --disable = {'org', "tex", "latex"},  -- list of language that will be disabled
                --disable = function(lang, bufnr) return (lang == 'org' or lang=='tex') and vim.b.large_buf end,
                disable = function(lang, bufnr) return vim.b.large_buf end,
                additional_vim_regex_highlighting = {'org', 'tex'}, -- Required since TS highlighter doesn't support all syntax features (conceal)
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
