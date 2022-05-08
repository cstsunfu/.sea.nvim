![Startify](./pic/main.png)

# Neovim Configure

## Install

1. Install `Neovim` >=0.7

2. Install `pynvim`
```
  pip install pynvim
```

3. Install `node.js`, `npm`, and `yarn`
```
curl -sL install-node.vercel.app/lts | bash
npm install --global yarn
```

4. Install `lolcat` for display the NEOVIM logo
```
Ubuntu:
    sudo apt install lolcat
OSX:
    brew install lolcat
```

5. Install `ag` or `rg`
```
OSX:
    brew install rg
Ubuntu:
    sudo apt-get install ripgrep
```

6. Install Nerd Font
```
Install Nerd Font Family: `DejaVuSansMono Nerd Font` or  what you want
Download from https://www.nerdfonts.com/
Install method depend on your os.
```
7. Install xclip (X11), wl-clipboard (Wayland), pngpaste (MacOS), for Clipboard Image

8. Make some link
```bash
./install.sh
```

9. User related setting in `lua/core/local.lua` and `lua/core/user.lua`.

Both `local.lua` and `user.lua` are bind to user. `user.lua` is more general for each user,  and `local.lua` is special to each machine, and setting in `local.lua`  will not be indexed by git but `user.lua` will be.

My own setting example in `local.lua` is:
```
vim.g.global_proxy_port = 'http://127.0.1.1:7893' -- like "http://127.0.0.1:7893", this is for some plugin like google translate that is banned by GFW. if you don't have this issue, set it to `nil`
```
And some setting personally but put to `local.lua` like:

```
local themes = require('core.themes')
themes.setting(themes.configs.material_oceanic)

local user_setting = {
    python3_host_prog = vim.g.HOME_PATH .. '/anaconda3/bin/python3', -- add to your own python3 path
    snips_author = 'Sun Fu',
    snips_email = 'cstsunfu@gmail.com',
    snips_github = 'https://github.com/cstsunfu',
    snips_wechat = 'cstsunfu',
}

for key, value in pairs(user_setting) do
    vim.g[key] = value
end
```

NOTE: The default leader is setting in `lua/core/default.lua`. The setting is 
```
let maplocalleader=','
let mapleader=';'
nnoremap \\ ;
vnoremap \\ ;
```

10. Open neovim and run `:PackerSync<cr>` command to install Plugins by Packer plugin manager.


## More

For getting the best performance, please use the GPU-based terminal:

* [kitty](https://github.com/kovidgoyal/kitty)
* [alacritty](https://github.com/jwilm/alacritty)

# Main features(Each figure may be displaied with different colorscheme.)

## Complete/Nvim-Tree/Navigator
![code_view_complete](./pic/code_view.png)

## Fuzzy Search
![Fuzzy Search](./pic/fuzzy_search.png)

## Agenda
![Agenda](./pic/orgmode.png)

## Markdown & Vimwiki
![Markdown & Vimwiki](./pic/markdown.png)

## Project TODO
![Project TODO](./pic/project_todo.png)

## Debug Adapter Protocol 
![Debug Adapter Protocol](./pic/debug_adapter_protocol.png)

## Pomodoro Clock 
![Pomodoro Clock](./pic/pomodoro.png)

TODO: More detail


```
.
├── coc-settings.json         -- coc lsp 设置，也可选内置LSP
├── compiler                  -- 编译相关配置
│   └── python.vim
├── ftplugin                  -- 和原来的vim script一样，根据文件类型加载模块                  
│   ├── lua.lua               
│   ├── python.lua            --                         
│   └── vimwiki.vim           --                          
├── init.lua                  -- neovim配置文件入口                  
├── init.lua
├── install.sh
├── lua
│   ├── configure
│   ├── core                  -- 核心模块                 
│   │   ├── after.lua         -- 后处理模块                    
│   │   ├── default.lua       -- 默认设置模块                             
│   │   ├── init.lua          -- 核心加载逻辑模块                         
│   │   ├── mapping.lua       -- 快捷键注册模块                             
│   │   ├── plugins.lua       -- 插件加载模块                             
│   │   └── themes.lua        -- 常用主题
│   ├── hack                  -- 用户自定义模块，插件半成品
│   │   ├── init.lua
│   │   └── pomodoro.lua
│   ├── local.lua             -- 机器相关配置，如代理等，不被git管理
│   ├── user.lua              -- 用户相关配置，如邮箱，姓名等，希望被git管理的配置放到user.lua里面，不希望被管理的用户相关的配置放到local里面
│   └── util                  -- 其他工具                  
│       ├── global.lua        -- 全局函数                            
│       ├── json.lua          -- json读写相关                          
│       └── path.lua          -- 路径读写相关                          
└── tasks.ini                 -- 任务定义                   

```
