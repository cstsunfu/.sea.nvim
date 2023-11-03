local global_mapping = {}

local used = {
    n = {},
    v = {},
    i = {},
    c = {},
    s = {},
    o = {},
    l = {},
    x = {},
    ["!"] = {},
    t = {},
    [""] = {}
}
local loaded_plugins = require('core.plugins').loaded_plugins

local mapping_prefix = {
    ["<leader><TAB>"] = { name = "+ Toggle fold" },
    ["<leader>a"] = { name = "+ AI" },
    ["<leader>b"] = { name = "+ Buffer" },
    ["<leader>c"] = { name = "+ Comment/Change" },
    ["<leader>d"] = { name = "+ Debug" },
    ["<leader>e"] = { name = "+ Eval" },
    ["<leader>f"] = { name = "+ File" },
    ["<leader>g"] = { name = "+ Git/Generator" },
    ["<leader>h"] = { name = "+ History" },
    ["<leader>j"] = { name = "+ Json/Jupyter" },
    ["<leader>l"] = { name = "+ Line" },
    ["<leader>m"] = { name = "+ Move" },
    ["<leader>n"] = { name = "+ New/Note" },
    ["<leader>o"] = { name = "+ Org" },
    ["<leader>p"] = { name = "+ Paste" },
    ["<leader>q"] = { name = "+ Quit/QuickFix" },
    ["<leader>r"] = { name = "+ Read/Remote" },
    ["<leader>s"] = { name = "+ Snip/Save/CtrlSF/Space/Sign/Source File" },
    ["<leader>t"] = { name = "+ Table/Terminal/Translate/Tab" },
    ["<leader>v"] = { name = "+ Visual" },
    ["<leader>w"] = { name = "+ Window" },
    ["<leader>x"] = { name = "+ Quit" },
    ["<leader>y"] = { name = "+ Yank" },
}

--local iomappings = io.open("/home/sun/a.md", "a")
global_mapping.register = function(new_map)
    --  mode = "n", --string or list of string         default : "n" or {"n"}
    --  key = {"<leader>", "f"},     required
    --  noremap = true,               default : true
    --  action = "",                  required
    --  short_desc = "",              default : No DESC
    --  desc = "",                    default = short_desc
    --  expr = nil,                   default = nil
    --  silent = nil,                 default = nil

    -- default
    if new_map['mode'] == nil then
        new_map['mode'] = 'n'
    end

    if type(new_map['mode']) == "table" then
        local map_list = new_map['mode']
        for i, val in ipairs(new_map['mode']) do
            new_map['mode'] = val
            if val == nil then
                print("The mode list is not support nil.")
            end
            global_mapping.register(new_map)
        end
        return
    end
    if new_map['short_desc'] == nil then
        new_map['short_desc'] = "NO DESC"
    end
    if new_map['desc'] == nil then
        new_map['desc'] = "NO DESC"
    end

    local option = {}
    option['noremap'] = true
    if new_map['noremap'] ~= nil then
        option['noremap'] = new_map.noremap
    end
    if new_map['expr'] ~= nil then
        option['expr'] = new_map['expr']
    end
    if new_map['silent'] ~= nil then
        option['silent'] = new_map['silent']
    end

    local uni_key_string = ""
    local key_list = {}

    for _, key in pairs(new_map.key) do
        if key == "<leader>" then
            uni_key_string = uni_key_string .. vim.g.mapleader
        elseif key == "<localleader>" then
            uni_key_string = uni_key_string .. vim.g.maplocalleader
        else
            uni_key_string = uni_key_string .. key
        end
        if key == vim.g.mapleader then
            table.insert(key_list, "<leader>")
        elseif key == vim.g.maplocalleader then
            table.insert(key_list, "<localleader>")
        else
            table.insert(key_list, key)
        end
    end
    --iomappings:write(new_map['mode'] .. '  |  ' .. uni_key_string .. '  |  ' .. new_map['short_desc']..'\n')

    if used[new_map['mode']][uni_key_string] then
        vim.print(used[new_map['mode']])
        print("Mode " .. new_map['mode'] .. " " .. uni_key_string .. " has been used for " .. used[new_map['mode']][uni_key_string] .. ", you should change " .. new_map["short_desc"] .. " to another one.")
        return
    else
        used[new_map['mode']][uni_key_string] = new_map['short_desc']
    end
    --vim.print(new_map.mode..'   '..uni_key_string..'    |'..new_map['short_desc'])
    if loaded_plugins.which_key and #key_list > 1 and new_map.mode == 'n' then
        local prefix = key_list[1]
        if #key_list > 1 then
            prefix = prefix .. key_list[2]
        end
        local tail = ""
        for i = 3, #key_list, 1 do
            tail = tail .. key_list[i]
        end
        if mapping_prefix[prefix] == nil then
            --print(prefix, new_map['short_desc'])
            mapping_prefix[prefix] = {}
            mapping_prefix[prefix]['name'] = new_map['short_desc']
        end
        if tail ~= "" then
            mapping_prefix[prefix][tail] = { new_map.action, new_map.short_desc }
        else
            mapping_prefix[prefix] = { new_map.action, new_map.short_desc }
        end
        if new_map['silent'] ~= nil then
            if tail ~= "" then
                mapping_prefix[prefix][tail]['silent'] = new_map['silent']
            else
                mapping_prefix[prefix]['silent'] = new_map['silent']
            end
        end
        if new_map['noremap'] ~= nil then
            if tail ~= "" then
                mapping_prefix[prefix][tail]['noremap'] = new_map['noremap']
            else
                mapping_prefix[prefix]['noremap'] = new_map['noremap']
            end
        end
    else
        if new_map.action ~= nil then
            vim.api.nvim_set_keymap(new_map.mode, uni_key_string, new_map.action, option)
        end
    end
end

global_mapping.register({
    mode = "i",
    key = { vim.g.mapleader },
    action = vim.g.mapleader,
    short_desc = "Leader Key"
})

global_mapping.register({
    mode = "i",
    key = { vim.g.maplocalleader },
    action = vim.g.maplocalleader,
    short_desc = "LocalLeader Key"
})

-- common mappings
global_mapping.register({
    mode = "x",
    key = { "<" },
    action = "<gv",
    short_desc = "Left Indent Selected"
})
global_mapping.register({
    mode = "x",
    key = { ">" },
    action = ">gv",
    short_desc = "Right Indent Selected"
})
global_mapping.register({
    mode = "i",
    key = { "k", "j" },
    action = "<esc>",
    short_desc = "Back to Normal Mode"
})
global_mapping.register({
    mode = "c",
    key = { "k", "j" },
    action = "<esc>",
    short_desc = "Back to Normal Mode"
})


-- buffer configure at bufferline plugin


-- paste

global_mapping.register({
    mode = "n",
    key = { "<leader>", "p" },
    action = '"+p',
    short_desc = "Paste From Clipboard"
})
global_mapping.register({
    mode = "i",
    key = { "<leader>", "p" },
    action = '<esc>"+p',
    short_desc = "Paste From Clipboard"
})

-- quit
global_mapping.register({
    mode = "n",
    key = { "<leader>", "q", "A" },
    action = ':qa!<cr>',
    short_desc = "Directly Quit Without Save"
})

global_mapping.register({
    mode = "n",
    key = { "<leader>", "q", "q" },
    action = ':qa<cr>',
    short_desc = "Directly Quit"
})

global_mapping.register({
    mode = "n",
    key = { "<leader>", "q", "w" },
    action = ':qa<cr>',
    short_desc = "Directly Quit After Write"
})

-- quickfix
global_mapping.register({
    mode = "n",
    key = { "<leader>", "q", "c" },
    action = ':cclose<cr>',
    short_desc = "QuickFix Close"
})

global_mapping.register({
    mode = "n",
    key = { "<leader>", "q", "o" },
    action = ':copen<cr>',
    short_desc = "QuickFix Open"
})

global_mapping.register({
    mode = "n",
    key = { "<leader>", "q", "p" },
    action = ':cprevious<cr>',
    short_desc = "QuickFix Previous Item"
})

global_mapping.register({
    mode = "n",
    key = { "<leader>", "q", "n" },
    action = ':cnext<cr>',
    short_desc = "QuickFix Next Item"
})

-- read
global_mapping.register({
    mode = "n",
    key = { "<leader>", "r", "d" },
    action = ':read !date <cr>',
    short_desc = "Read Date From System"
})

global_mapping.register({
    mode = "n",
    key = { "<leader>", "r", "r" },
    action = ':e!<cr>',
    short_desc = "Reload Current File"
})

global_mapping.register({
    mode = "n",
    key = { "<leader>", "r", "t" },
    action = ':read !tree<cr>',
    short_desc = "Read FileTree"
})

--save/space/source file
_G.source_current_file = function()
    local source_filetypes = {'lua', 'vim'}
    for _, filetype in ipairs(source_filetypes) do
        if vim.bo.filetype == filetype then
            vim.cmd('source %')
            return
        end
    end
    vim.notify('You Can Only Source Lua/Vim File')
end

global_mapping.register({
    mode = "n",
    key = { "<leader>", "s", "." },
    action = ':lua _G.source_current_file()<cr>',
    silent = false,
    short_desc = "Source Current File"
})

global_mapping.register({
    mode = "n",
    key = { "<leader>", "s", "<space>" },
    action = ':%s/\\s\\+$//<cr>',
    short_desc = "Remove Tail Space"
})

global_mapping.register({
    mode = "n",
    key = { "<leader>", "s", "s" },
    action = ':w<cr>',
    short_desc = "Save Current Buffer"
})

global_mapping.register({
    mode = "n",
    key = { "<leader>", "s", "a" },
    action = ':wa<cr>',
    short_desc = "Save All Buffers"
})

-- tab configure at bufferline plugin

-- window

global_mapping.register({
    mode = "n",
    key = { "<leader>", "w", "s" },
    action = ':split<cr>',
    short_desc = "Split Window"
})
global_mapping.register({
    mode = "n",
    key = { "<leader>", "w", "v" },
    action = ':vsplit<cr>',
    short_desc = "Vertical Split Window"
})
global_mapping.register({
    mode = "n",
    key = { "<leader>", "w", "d" },
    action = ':q<cr>',
    short_desc = "Close Current Window"
})
global_mapping.register({
    mode = "n",
    key = { "<leader>", "w", "o" },
    action = ':only<cr>',
    short_desc = "Only Reserve Current Window"
})
global_mapping.register({
    mode = "n",
    key = { "<leader>", "w", "w" },
    action = '<c-w><c-w>',
    short_desc = "Goto Next Window"
})
global_mapping.register({
    mode = "n",
    key = { "<leader>", "w", "j" },
    action = '<c-w><c-j>',
    short_desc = "Goto The Down Window"
})
global_mapping.register({
    mode = "n",
    key = { "<leader>", "w", "k" },
    action = '<c-w><c-k>',
    short_desc = "Goto The Above Window"
})
global_mapping.register({
    mode = "n",
    key = { "<leader>", "w", "h" },
    action = '<c-w><c-h>',
    short_desc = "Goto The Left Window"
})
global_mapping.register({
    mode = "n",
    key = { "<leader>", "w", "l" },
    action = '<c-w><c-l>',
    short_desc = "Goto The Right Window"
})

global_mapping.register({
    mode = "n",
    key = { "<leader>", "w", "J" },
    action = '<c-w><c-J>',
    short_desc = "Goto The Bottom Window"
})
global_mapping.register({
    mode = "n",
    key = { "<leader>", "w", "K" },
    action = '<c-w><c-K>',
    short_desc = "Goto The Top Window"
})
global_mapping.register({
    mode = "n",
    key = { "<leader>", "w", "H" },
    action = '<c-w><c-H>',
    short_desc = "Goto The Leftest Window"
})
global_mapping.register({
    mode = "n",
    key = { "<leader>", "w", "L" },
    action = '<c-w><c-L>',
    silent = true,
    short_desc = "Goto The Rightest Window"
})

-- x exit, exec

global_mapping.register({
    mode = "n",
    key = { "<leader>", "x" },
    action = ':close<cr>',
    silent = true,
    short_desc = "Close Current Window"
})

-- y yank
local system_info = io.popen('uname -a')
local system_info = system_info:read("*all")
local has_wsl = string.find(system_info, 'Microsoft')

if has_wsl ~= nil then
    global_mapping.register({
        mode = "v",
        key = { "<leader>", "y" },
        action = ':w !clip.exe<cr><cr>',
        silent = true,
        short_desc = "Yank to Clipboard"
    })
else
    global_mapping.register({
        mode = "v",
        key = { "<leader>", "y" },
        action = '"+y',
        short_desc = "Yank to Clipboard"
    })
end

-- z fold

global_mapping.register({
    mode = "n",
    key = { "<leader>", "<TAB>" },
    action = "@=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>",
    short_desc = "Smart toggle fold",
    silent = true
})

global_mapping.register({
    mode = "n",
    key = {"z", "R"},
    action = 'zR',
    short_desc = "Unzip all",
    silent = true
})

global_mapping.register({
    mode = "n",
    key = {"z", "r"},
    action = 'zr',
    short_desc = "Unzip",
    silent = true
})

global_mapping.register({
    mode = "n",
    key = {"z", "a"},
    action = 'za',
    short_desc = "Zip toggle",
    silent = true
})

global_mapping.register({
    mode = "n",
    key = {"z", "m"},
    action = 'zm',
    short_desc = "Zip current",
    silent = true
})

global_mapping.register({
    mode = "n",
    key = {"z", "M"},
    action = 'zM',
    short_desc = "Zip all",
    silent = true
})

global_mapping.register({
    mode = "n",
    key = {"z", "o"},
    action = 'zo',
    short_desc = "Unzip current",
    silent = true
})
-- Alt
if vim.fn.has('mac') == 1 then
    global_mapping.register({
        mode = { "n", 'v', 't' },
        key = { "¬" },
        action = '<C-\\><C-N>:wincmd l<cr>',
        short_desc = "<alt-l>Goto Right Window"
    })
    global_mapping.register({
        mode = { "n", 'v', 't' },
        key = { "˚" },
        action = '<C-\\><C-N>:wincmd k<cr>',
        short_desc = "<alt-k>Goto Above Window"
    })
    global_mapping.register({
        mode = { "n", 'v', 't' },
        key = { "˙" },
        action = '<C-\\><C-N>:wincmd h<cr>',
        short_desc = "<alt-h>Goto Left Window"
    })
    global_mapping.register({
        mode = { "n", 'v', 't' },
        key = { "∆" },
        action = '<C-\\><C-N>:wincmd j<cr>',
        short_desc = "<alt-j>Goto Below Window"
    })
    global_mapping.register({
        mode = { "n", 'v', 't' },
        key = { "ƒ" },
        action = '<C-\\><C-N>:bnext<cr>',
        short_desc = "<alt-f>Go to Next Buffer"
    })
    global_mapping.register({
        mode = { "n", 'v', 't' },
        key = { "∫" },
        action = '<C-\\><C-N>:bprevious<cr>',
        short_desc = "<alt-b>Go to Previous Buffer"
    })
    global_mapping.register({
        mode = { "n", 'v', 't' },
        key = { "∑" },
        action = '<C-\\><C-N>:resize +5<cr>',
        short_desc = "<alt-w>Size +5"
    })
    global_mapping.register({
        mode = { "n", 'v', 't' },
        key = { "ß" },
        action = '<C-\\><C-N>:resize -5<cr>',
        short_desc = "<alt-s>Size -5"
    })
    global_mapping.register({
        mode = { "n", 'v', 't' },
        key = { "å" },
        action = '<C-\\><C-N>:vertical resize -5<cr>',
        short_desc = "<alt-a>Vertical Size -5"
    })
    global_mapping.register({
        mode = { "n", 'v', 't' },
        key = { "∂" },
        action = ':vertical resize +5<cr>',

        noresmap = true,
        short_desc = "<alt-d>Vertical Size +5"
    })
else
    global_mapping.register({
        mode = { "n", 'v', 't' },
        key = { "<A-l>" },
        action = '<C-\\><C-N>:wincmd l<cr>',
        short_desc = "<alt-l>Goto Right Window"
    })
    global_mapping.register({
        mode = { "n", 'v', 't' },
        key = { "<A-k>" },
        action = '<C-\\><C-N>:wincmd k<cr>',
        short_desc = "<alt-k>Goto Above Window"
    })
    global_mapping.register({
        mode = { "n", 'v', 't' },
        key = { "<A-h>" },
        action = '<C-\\><C-N>:wincmd h<cr>',
        short_desc = "<alt-h>Goto Left Window"
    })
    global_mapping.register({
        mode = { "n", 'v', 't' },
        key = { "<A-j>" },
        action = '<C-\\><C-N>:wincmd j<cr>',
        short_desc = "<alt-j>Goto Below Window"
    })
    global_mapping.register({
        mode = { "n", 'v', 't' },
        key = { "<A-f>" },
        action = '<C-\\><C-N>:bnext<cr>',
        short_desc = "<alt-f>Go to Next Buffer"
    })
    global_mapping.register({
        mode = { "n", 'v', 't' },
        key = { "<A-b>" },
        action = '<C-\\><C-N>:bprevious<cr>',
        short_desc = "<alt-b>Go to Previous Buffer"
    })
    global_mapping.register({
        mode = { "n", 'v', 't' },
        key = { "<A-w>" },
        action = '<C-\\><C-N>:resize +5<cr>',
        short_desc = "<alt-w>Size +5"
    })
    global_mapping.register({
        mode = { "n", 'v', 't' },
        key = { "<A-s>" },
        action = '<C-\\><C-N>:resize -5<cr>',
        short_desc = "<alt-s>Size -5"
    })
    global_mapping.register({
        mode = { "n", 'v', 't' },
        key = { "<A-a>" },
        action = '<C-\\><C-N>:vertical resize -5<cr>',
        short_desc = "<alt-a>Vertical Size -5"
    })
    global_mapping.register({
        mode = { "n", 'v', 't' },
        key = { "<A-d>" },
        action = '<C-\\><C-N>:vertical resize +5<cr>',
        short_desc = "<alt-d>Vertical Size +5"
    })
end

-- ctrl
global_mapping.register({
    mode = "n",
    key = { "<C-j>" },
    action = '5j',
    short_desc = "5j"
})
global_mapping.register({
    mode = "n",
    key = { "<C-k>" },
    action = '5k',
    short_desc = "5k"
})
global_mapping.register({
    mode = "v",
    key = { "<C-j>" },
    action = '5j',
    short_desc = "5j"
})
global_mapping.register({
    mode = "v",
    key = { "<C-k>" },
    action = '5k',
    short_desc = "5k"
})

-- space
global_mapping.register({
    mode = "n",
    key = { "<space>", "<enter>" },
    action = ':nohlsearch<cr>',
    short_desc = "No Search Highlight"
})

-- emacs key binding for insert mode
global_mapping.register({
    mode = "i",
    key = { "<C-u>" },
    noremap = true,
    action = '<C-[>bdiwa',
    short_desc = "Delete Prior Word"
})

global_mapping.register({
    mode = "i",
    key = { "<C-h>" },
    noremap = true,
    action = '<BS>',
    short_desc = "Delete Prior Word"
})
global_mapping.register({
    mode = "i",
    key = { "<C-d>" },
    noremap = true,
    action = '<Del>',
    short_desc = "Delete Next Char"
})
global_mapping.register({
    mode = "i",
    key = { "<C-b>" },
    noremap = true,
    action = '<Left>',
    short_desc = "Go Left"
})
global_mapping.register({
    mode = "i",
    key = { "<C-f>" },
    noremap = true,
    action = '<Right>',
    short_desc = "Go Right"
})
global_mapping.register({
    mode = "i",
    key = { "<C-a>" },
    noremap = true,
    action = '<ESC>^i',
    short_desc = "Go To The Begin and Insert"
})
global_mapping.register({
    mode = "i",
    key = { "<C-e>" },
    action = '<ESC>$a',
    short_desc = "Go To The End and Append"
})
global_mapping.register({
    mode = "i",
    key = { "<C-O>" },
    action = '<Esc>o',
    short_desc = "New Line and Insert"
})
global_mapping.register({
    mode = "i",
    key = { "<C-S>" },
    action = '<esc>:w<CR>',
    short_desc = "Save"
})
global_mapping.register({
    mode = { "i", "n"},
    key = { "<C-Q>" },
    action = '<esc>:wq<CR>',
    short_desc = "Save & Quit"
})

-- g
--
-- map helper
if vim.fn.has("mac") == 1 then

    global_mapping.register({
        mode = { "v", "n"},
        key = { "g", "x" },
        action = '<Cmd>call jobstart(["open", expand("<cfile>")], {"detach": v:true})<CR>',
        short_desc = "Open URL Link"
    })
elseif vim.fn.has("unix") == 1 then
    global_mapping.register({
        mode = { "v", "n"},
        key = { "g", "x" },
        action = '<Cmd>call jobstart(["xdg-open", expand("<cfile>")], {"detach": v:true})<CR>',
        short_desc = "Open URL Link"
    })
end

global_mapping.setup = function()

    vim.cmd([[
        inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<tab>"
        inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
    ]])
    if loaded_plugins.which_key then
        local wk = require("which-key")
        wk.register(mapping_prefix)
    end

end
return global_mapping

