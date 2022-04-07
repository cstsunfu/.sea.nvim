![Dashboard](./pic/dashboard.png)

# Neovim Configure

## Install

1. Install Neovim >0.6
```
  pip install pynvim
```
2. Install node.js, npm, and yarn
```
curl -sL install-node.vercel.app/lts | bash
npm install --global yarn
```
3. Install ag or rg
```
like:
    brew install rg
    sudo apt-get install ripgrep
```
4. Install Nerd Font
```
Install Nerd Font Family: `DejaVuSansMono Nerd Font` or  what you want
Download from https://www.nerdfonts.com/
Install method depend on you os.
```

5. Make some link
```bash
./install.sh
```


# Main features
## Fuzzy Search
![Fuzzy Search](./pic/fuzzy_search.png)

## Complete by Coc
![Complete by Coc](./pic/complete.png)

## Agenda
![Agenda](./pic/orgmode.png)

## Markdown & Vimwiki
![Markdown & Vimwiki](./pic/markdown.png)

## Project TODO
![Project TODO](./pic/project_todo.png)

## Code View & File View
![Code View](./pic/code_view.png)

## Debug Adapter Protocol 
![Debug Adapter Protocol](./pic/debug_adapter_protocol.png)

## Pomodoro Clock 
![Pomodoro Clock](./pic/pomodoro.png)

## Window Number 
![Window Number](./pic/split_window.png)

## WhichKey 
![WhichKey](./pic/which_key.png)

TODO: detail





```

.
├── coc-settings.json         -- coc lsp 设置，也可选内置LSP
├── ftplugin                  -- 和原来的vim script一样，根据文件类型加载模块                  
│   ├── python.vim            --                         
│   └── vimwiki.vim           --                          
├── init.lua                  -- neovim配置文件入口                  
├── lua                       -- lua 相关                 
│   ├── configure             -- 每个插件一个配置文件                       
│   │   ├── coc.lua           --                          
│   │   ├── ....              --                       
│   ├── core                  -- 核心模块                 
│   │   ├── after.lua         -- 后处理模块                    
│   │   ├── default.lua       -- 默认设置模块                             
│   │   ├── init.lua          -- 核心加载逻辑模块                         
│   │   ├── mapping.lua       -- 快捷键注册模块                             
│   │   └── plugins.lua       -- 插件加载模块                             
│   ├── user                  -- 用户自定义模块                 
│   │   ├── init.lua          --                           
│   │   └── pomodoro.lua      --                              
│   └── util                  -- 其他工具                  
│       ├── global.lua        -- 全局函数                            
│       ├── json.lua          -- json读写相关                          
│       └── path.lua          -- 路径读写相关                          
└── tasks.ini                 -- 任务定义                   
                              
```
