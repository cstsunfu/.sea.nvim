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
local plugins_groups = require('core.plugins').plugins_groups

local mapping_prefix = {
    ["<leader><TAB>"] = { name = "+ Toggle fold" },
    ["<leader>b"] = { name = "+ Buffer" },
    ["<leader>c"] = { name = "+ Comment/Change" },
    ["<leader>d"] = { name = "+ Debug" },
    ["<leader>e"] = { name = "+ Eval" },
    ["<leader>f"] = { name = "+ File" },
    ["<leader>g"] = { name = "+ Git/Generator" },
    --["<leader>G"] = {name = "+ Git"},
    ["<leader>h"] = { name = "+ History" },
    ["<leader>j"] = { name = "+ Json/Jupyter" },
    ["<leader>l"] = { name = "+ Line" },
    ["<leader>m"] = { name = "+ Move" },
    ["<leader>o"] = { name = "+ Org" },
    ["<leader>p"] = { name = "+ Paste" },
    ["<leader>q"] = { name = "+ Quit/QuickFix" },
    ["<leader>r"] = { name = "+ Read" },
    ["<leader>s"] = { name = "+ Snip/Save/CtrlSF/Space/Sign" },
    ["<leader>t"] = { name = "+ Table/Terminal/Translate/Tab" },
    ["<leader>v"] = { name = "+ Visual" },
    ["<leader>w"] = { name = "+ Window" },
    ["<leader>x"] = { name = "+ Quit" },
    ["<leader>y"] = { name = "+ Yank" },
    ["<leader>1"] = { name = "+ Go buffer 1" },
    ["<leader>2"] = { name = "+ Go buffer 2" },
    ["<leader>3"] = { name = "+ Go buffer 3" },
    ["<leader>4"] = { name = "+ Go buffer 4" },
    ["<leader>5"] = { name = "+ Go buffer 5" },
    ["<leader>6"] = { name = "+ Go buffer 6" },
    ["<leader>7"] = { name = "+ Go buffer 7" },
    ["<leader>8"] = { name = "+ Go buffer 8" },
    ["<leader>9"] = { name = "+ Go buffer 9" }
}


global_mapping.register = function(new_map)
    --  mode = "n", --string or list of string         default : "n" or {"n"}
    --  key = {"<leader>", "f"},     required
    --  noremap = nil,               default : nil
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
    --print(new_map['mode'] .. '     ' .. uni_key_string .. '     ' .. new_map['short_desc'])

    if used[new_map['mode']][uni_key_string] then
        print("Mode " .. new_map['mode'] .. " " .. uni_key_string .. " has been used for " .. used[new_map['mode']][uni_key_string] .. ", you should change " .. new_map["short_desc"] .. " to another one.")
        return
    else
        used[new_map['mode']][uni_key_string] = new_map['short_desc']
    end
    --local prefix = key_list[1]
    --if plugins_groups['default']['which_key'] and plugins_groups['default']['which_key']['disable'] == false and key_list[1] == "<leader>" and new_map.mode == 'n' then
    if plugins_groups['default']['which_key'] and plugins_groups['default']['which_key']['disable'] == false and #key_list > 1 and new_map.mode == 'n' then
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
})

global_mapping.register({
    mode = "i",
    key = { vim.g.maplocalleader },
    action = vim.g.maplocalleader,
})

-- common mappings
global_mapping.register({
    mode = "x",
    key = { "<" },
    action = "<gv",
})
global_mapping.register({
    mode = "x",
    key = { ">" },
    action = ">gv",
})
global_mapping.register({
    mode = "t",
    key = { "<esc>" },
    action = "<C-\\><C-n>",
})
global_mapping.register({
    mode = "i",
    key = { "j", "k" },
    action = "<esc>",
})
global_mapping.register({
    mode = "c",
    key = { "j", "k" },
    action = "<esc>",
})
global_mapping.register({
    mode = "t",
    key = { "j", "k" },
    action = "<esc>",
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
    key = { "<leader>", "q", "q" },
    action = ':qa<cr>',
    short_desc = "Directly Quit"
})

global_mapping.register({
    mode = "n",
    key = { "<leader>", "q", "w" },
    action = ':qaw<cr>',
    short_desc = "Directly Quit After Write"
})

-- quickfix
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

--save/space

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
    short_desc = "Goto The Rightest Window"
})

-- x exit, exec

global_mapping.register({
    mode = "n",
    key = { "<leader>", "x" },
    action = ':close<cr>',
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

-- Alt
if vim.fn.has('mac') == 1 then
    global_mapping.register({
        mode = { "n", "v", "i", "t" },
        key = { "¬" },
        action = '<esc>:wincmd l<cr>',
        short_desc = "<alt-l>Goto Right Window"
    })
    global_mapping.register({
        mode = { "n", "v", "i", "t" },
        key = { "˚" },
        action = '<esc>:wincmd k<cr>',
        short_desc = "<alt-k>Goto Above Window"
    })
    global_mapping.register({
        mode = { "n", "v", "i", "t" },
        key = { "˙" },
        action = '<esc>:wincmd h<cr>',
        short_desc = "<alt-h>Goto Left Window"
    })
    global_mapping.register({
        mode = { "n", "v", "i", "t" },
        key = { "∆" },
        action = '<esc>:wincmd j<cr>',
        short_desc = "<alt-j>Goto Below Window"
    })
    global_mapping.register({
        mode = { "n", "v", "i", "t" },
        key = { "ƒ" },
        action = '<esc>:bnext<cr>',
        short_desc = "<alt-f>Go to Next Buffer"
    })
    global_mapping.register({
        mode = { "n", "v", "i", "t" },
        key = { "∫" },
        action = '<esc>:bprevious<cr>',
        short_desc = "<alt-b>Go to Previous Buffer"
    })
    global_mapping.register({
        mode = { "n", "v", "i", "t" },
        key = { "∑" },
        action = '<esc>:resize +5<cr>',
        short_desc = "<alt-w>Size +5"
    })
    global_mapping.register({
        mode = { "n", "v", "i", "t" },
        key = { "ß" },
        action = '<esc>:resize -5<cr>',
        short_desc = "<alt-s>Size -5"
    })
    global_mapping.register({
        mode = { "n", "v", "i", "t" },
        key = { "å" },
        action = '<esc>:vertical resize -5<cr>',
        short_desc = "<alt-a>Vertical Size -5"
    })
    global_mapping.register({
        mode = { "n", "v", "i", "t" },
        key = { "∂" },
        action = '<esc>:vertical resize +5<cr>',
        short_desc = "<alt-d>Vertical Size +5"
    })
else
    global_mapping.register({
        mode = { "n", "v", "i", "t" },
        key = { "<A-l>" },
        action = '<esc>:wincmd l<cr>',
        short_desc = "<alt-l>Goto Right Window"
    })
    global_mapping.register({
        mode = { "n", "v", "i", "t" },
        key = { "<A-k>" },
        action = '<esc>:wincmd k<cr>',
        short_desc = "<alt-k>Goto Above Window"
    })
    global_mapping.register({
        mode = { "n", "v", "i", "t" },
        key = { "<A-h>" },
        action = '<esc>:wincmd h<cr>',
        short_desc = "<alt-h>Goto Left Window"
    })
    global_mapping.register({
        mode = { "n", "v", "i", "t" },
        key = { "<A-j>" },
        action = '<esc>:wincmd j<cr>',
        short_desc = "<alt-j>Goto Below Window"
    })
    global_mapping.register({
        mode = { "n", "v", "i", "t" },
        key = { "<A-f>" },
        action = '<esc>:bnext<cr>',
        short_desc = "<alt-f>Go to Next Buffer"
    })
    global_mapping.register({
        mode = { "n", "v", "i", "t" },
        key = { "<A-b>" },
        action = '<esc>:bprevious<cr>',
        short_desc = "<alt-b>Go to Previous Buffer"
    })
    global_mapping.register({
        mode = { "n", "v", "i", "t" },
        key = { "<A-w>" },
        action = '<esc>:resize +5<cr>',
        short_desc = "<alt-w>Size +5"
    })
    global_mapping.register({
        mode = { "n", "v", "i", "t" },
        key = { "<A-s>" },
        action = '<esc>:resize -5<cr>',
        short_desc = "<alt-s>Size -5"
    })
    global_mapping.register({
        mode = { "n", "v", "i", "t" },
        key = { "<A-a>" },
        action = '<esc>:vertical resize -5<cr>',
        short_desc = "<alt-a>Vertical Size -5"
    })
    global_mapping.register({
        mode = { "n", "v", "i", "t" },
        key = { "<A-d>" },
        action = '<esc>:vertical resize +5<cr>',
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
    key = { "<C-w>" },
    action = '<C-[>diwa',
    short_desc = "Delete Prior Word"
})
global_mapping.register({
    mode = "i",
    key = { "<C-h>" },
    action = '<BS>',
    short_desc = "Delete Prior Char"
})
global_mapping.register({
    mode = "i",
    key = { "<C-d>" },
    action = '<Del>',
    short_desc = "Delete Next Char"
})
global_mapping.register({
    mode = "i",
    key = { "<C-k>" },
    action = '<ESC>d$a',
    short_desc = "Delete To The End"
})
global_mapping.register({
    mode = "i",
    key = { "<C-u>" },
    action = '<C-G>u<C-U>',
    short_desc = "Delete To The Begin"
})
global_mapping.register({
    mode = "i",
    key = { "<C-b>" },
    action = '<Left>',
    short_desc = "Go Left"
})
global_mapping.register({
    mode = "i",
    key = { "<C-f>" },
    action = '<Right>',
    short_desc = "Go Right"
})
global_mapping.register({
    mode = "i",
    key = { "<C-a>" },
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
    mode = "i",
    key = { "<C-Q>" },
    action = '<esc>:wq<CR>',
    short_desc = "Save & Quit"
})

global_mapping.setup = function()
    local plugins_config = require('core.plugins')
    if plugins_config.all_loaded_module['indent_line'] ~= nil then
        global_mapping.register({
            mode = "n",
            key = { "<leader>", "<TAB>" },
            action = "za:IndentBlanklineRefresh<CR>",
            short_desc = "Smart toggle fold",
            silent = true
        })
    else
        global_mapping.register({
            mode = "n",
            key = { "<leader>", "<TAB>" },
            action = "@=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>",
            short_desc = "Smart toggle fold",
            silent = true
        })
    end

    vim.cmd([[
        inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<tab>"
        inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
    ]])
    if plugins_config.plugins_groups['default']['which_key'] and plugins_config.plugins_groups['default']['which_key']['disable'] == false then
        vim.cmd("packadd which-key")
        local wk = require("which-key")
        wk.register(mapping_prefix)
    end

end
return global_mapping
