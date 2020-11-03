if exists('g:load_default_plugin') && g:load_default_plugin
    Plug 'scrooloose/nerdcommenter'
    Plug 'AndrewRadev/linediff.vim', {'on': 'Linediff'}        "比较两个区域的diff
    Plug 'terryma/vim-multiple-cursors'     "多光标
    Plug 'tpope/vim-fugitive', {'on': ['Gblame', 'Gcommit', 'Gedit' , 'Gdiff', 'Ggrep' , 'Glog' , 'Gmove' , 'Gread', 'Gstatus', 'Gwrite']}
    Plug 'gregsexton/gitv', {'on': ['Gitv']} " extension for fugitive :Gitv
    Plug 'mbbill/undotree',{'on':'UndotreeToggle'}  "undo tree
    Plug 'dyng/ctrlsf.vim', {'on':'CtrlSF'}  "ctrlsf from sublime text
    Plug 'tpope/vim-repeat'     "repeat some action which is not suported as standard vim
    Plug 'tpope/vim-surround' "添加surround 用法：cs"'   ds"   ysiw' ysiw<tag> yss'
    Plug 'houtsnip/vim-emacscommandline' "commandline  map  emacs
    Plug 'vim-scripts/Auto-Pairs'
    Plug 'tpope/vim-abolish'    "enhance  the search by using command 'S' ex. :%S/P{erson, eople}/User{.s}/g
    Plug 'SirVer/ultisnips'    "usnip_con
    Plug 'cstsunfu/vim-snippets'
    Plug 'sheerun/vim-polyglot' "多语言语法支持
    Plug 'moll/vim-bbye'        "when you close the buffer the window could be reserve
endif

if exists('g:load_indentline') && g:load_indentline
    Plug 'Yggdroot/indentLine'  "缩进线
endif

if exists('g:load_smooth_scroll') && g:load_smooth_scroll
    Plug 'psliwka/vim-smoothie'
    Plug 'rhysd/accelerated-jk'
endif

if exists('g:load_fzf') && g:load_fzf
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'markwu/vim-mrufiles'
endif

if exists('g:load_jupyter_vim') && g:load_jupyter_vim
    Plug 'jupyter-vim/jupyter-vim', {'for': 'python'}
endif

if exists('g:load_mirror') && g:load_mirror
    Plug 'zenbro/mirror.vim', { 'on': [ 'MirrorEdit', 'MirrorConfig' ] }
endif

if exists('g:load_enhance_markdown') && g:load_enhance_markdown
    Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install', 'for': 'markdown'  }
    Plug 'dhruvasagar/vim-table-mode', {'for':'markdown'} 
endif

if exists('g:load_vimspector') && g:load_vimspector
    Plug 'puremourning/vimspector'
endif

if exists('g:load_asyncrun') && g:load_asyncrun
    Plug 'skywind3000/asynctasks.vim'
    Plug 'skywind3000/asyncrun.vim'
endif

if exists('g:load_lang_latex') && g:load_lang_latex
    Plug 'xuhdev/vim-latex-live-preview',{'for': 'tex'}
    Plug 'lervag/vimtex',{'for': 'tex'}
endif

if exists('g:load_beauty_vim') && g:load_beauty_vim
    Plug 'ryanoasis/vim-devicons'
    Plug 'junegunn/limelight.vim', {'on':'Limelight'}  " light the cursor
    Plug 'mhinz/vim-startify'  " my start page
    Plug 'octol/vim-cpp-enhanced-highlight', {'for':'cpp'} "cpp高亮加强查件
    Plug 'vim-python/python-syntax', {'for':'python'}  "python syntax enhance
endif


if exists('g:load_airline') && g:load_airline
    Plug 'vim-airline/vim-airline'
endif

if exists('g:load_easy_change') && g:load_easy_change
    Plug 'vim-scripts/DrawIt' "画图插件
    Plug 'gavinbeatty/dragvisuals.vim'
    Plug 'dhruvasagar/vim-zoom' "This plugin could not use with tagbar or nerdtree etc.
endif

if exists('g:load_wakatime') && g:load_wakatime
    Plug 'wakatime/vim-wakatime'
endif

if exists('g:load_org_my_life') && g:load_org_my_life
    Plug 'nathangrigg/vim-beancount', {'for': 'beancount'}
    Plug 'vimwiki/vimwiki' "vimwiki
    Plug 'dhruvasagar/vim-dotoo'
endif

if exists('g:load_translate_me') && g:load_translate_me
    Plug 'voldikss/vim-translate-me', {'on':['<Plug>TranslateW', '<Plug>TranslateR']}
endif

if exists('g:load_format') && g:load_format
    Plug 'sbdchd/neoformat'
    Plug 'tpope/vim-jdaddy', {'for': 'json'}
endif

if exists('g:load_nerd_tree') && g:load_nerd_tree
    Plug 'scrooloose/nerdtree', {'on':'NERDTreeToggle'}       "nt_con list the files in the same dirrectory
    Plug 'Xuyuanp/nerdtree-git-plugin', {'on':'NERDTreeToggle'}  
    Plug 'jistr/vim-nerdtree-tabs', {'on':'NERDTreeToggle'}  
endif

if exists('g:load_defx') && g:load_defx
    Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'kristijanhusak/defx-icons'
endif

if exists('g:load_colorschemes') && g:load_colorschemes
    Plug 'mhartington/oceanic-next'
    Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
    Plug 'arcticicestudio/nord-vim'
    Plug 'dracula/vim', { 'as': 'dracula' }
    Plug 'joshdick/onedark.vim'
    Plug 'morhetz/gruvbox'          "spacevim colorscheme
    Plug 'rakr/vim-one'
    Plug 'ajmwagar/vim-deus'
    Plug 'liuchengxu/space-vim-dark'        "spacemacs colorscheme
    Plug 'vim-airline/vim-airline-themes'
    Plug 'glepnir/oceanic-material'
    Plug 'overcache/NeoSolarized'
    Plug 'ashfinal/vim-colors-violet'
    Plug 'gosukiwi/vim-atom-dark'
    Plug 'drewtempelmeyer/palenight.vim'
endif

if exists('g:load_ale') && g:load_ale
    Plug 'w0rp/ale'     "syntax check
endif

if exists('g:load_vista') && g:load_vista
    Plug 'liuchengxu/vista.vim'
endif

if exists('g:load_ycm') && g:load_ycm
    Plug 'Valloric/YouCompleteMe'
endif

if exists('g:load_goyo') && g:load_goyo
    Plug 'junegunn/goyo.vim'
endif
