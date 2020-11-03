# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#!/bin/zsh
# File              : .zshrc
# Author            : Sun Fu <cstsunfu@gmail.com>
# Date              : 27.06.2018
# Last Modified Date: 01.07.2019
# Last Modified By  : Sun Fu <cstsunfu@gmail.com>
# If you come from bash you might have to change your $PATH.
defaults write TeXShop BringPdfFrontOnAutomaticUpdate NO
export PATH=$HOME/.local/bin:/usr/local/bin:$PATH
export PATH=/usr/local/texlive/2018/bin/:$PATH

# fzf
#export FZF_DEFAULT_COMMAND='fd --type file'
#export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
#export FZF_ALT_C_COMMAND="fd -t d . "

export FZF_DEFAULT_OPTS='--height 65% --border --color "border:#00ffff,info:#ffff00" --preview "bat --style=numbers --color=always {} | head -200"'
#export FZF_DEFAULT_OPTS='--height 45%  --color "border:#00ffff,info:#ffff00" --preview "head -100 {}"'
#export FZF_DEFAULT_OPTS="--height 45% --color 'fg:#bbccdd,fg+:#ddeeff,bg:#334455,border:#00ffff' --preview 'head -100 {}'"



# Path to your oh-my-zsh installation.
  export ZSH=$HOME/.oh-my-zsh
  #export CLICOLOR=1
  #export LSCOLORS=GxFxCxDxBxegedabagaced

# User specific aliases and functions
#export GTK_IM_MODULE=fcitx  
#export QT_IM_MODULE=fcitx  
#export XMODIFIERS="@im=fcitx"

# added by Anaconda3 installer
# export PATH="$HOME/anaconda3/bin:$PATH"  # commented out by conda initialize  # commented out by conda initialize
alias skim='/Applications/Skim.app/Contents/MacOS/Skim'
alias chrome="/Applications/Google\\ \\Chrome.app/Contents/MacOS/Google\\ \\Chrome"
alias  ipy="jupyter console"
alias nb="jupyter notebook"
alias  pdf='evince&'
alias  timeout='gtimeout'
#alias aria2c='aria2c --conf-path=/Users/sun/aria2.conf'
# alias  vim='nvim'
export TERM=xterm-256color
alias vi='function __vi() { if [[ $# == 0 ]]; then nvim; else {touch $*; nvim $*} fi}; __vi' 
alias  cl='colorls'
alias  cls='clear'
#alias  ll='\ls -l'
alias  ca='conda activate'
alias  cda='conda deactivate'
export EDITOR=vim

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="robbyrussell"
#ZSH_THEME="agnoster"
#ZSH_THEME="drofloh"
ZSH_THEME="powerlevel10k/powerlevel10k"
# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  web-search
  bundler
  dotenv
  osx
  rake
  rbenv
  ruby
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# ou may need to manually set your language environment
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
#source ~/powerlevel10k/powerlevel10k.zsh-theme

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/sun/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/sun/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/sun/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/sun/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
if [ -n "$CONDA_DEFAULT_ENV" ]; then                                                                                                                                         
    __conda_reactivate                                                                                                                                                       
fi
export PATH="/Users/sun/.local/odps_clt/bin:$PATH"
export PATH="/usr/local/Celler/vim/8.2.1250/bin:$PATH"
JAVA_HOME='/Library/Java/JavaVirtualMachines/jdk1.8.0_271.jdk/Contents/Home'
JAVA_HOME='/Library/Java/JavaVirtualMachines/jdk-11.0.9.jdk/Contents/Home'
export JAVA_HOME
export PATH="$JAVA_HOME/bin:$PATH"
export PATH="$HOME/.local/apache-maven-3.6.3/bin:$PATH"

