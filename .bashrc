# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
alias  pdf='evince&'
#alias  vim='vimx'
alias  vim='nvim'
alias  cl='colorls'
alias  cls='clear'
#alias  ll='\ls -l'
export EDITOR=vim
##export TERM=xterm-256color
#export TERM=xterm+256colors
set completion-ignore-case on
PS1="[\[\e[36;1m\]\u@\[\e[32;1m\]\h\[\e[0m\] \[\e[35;1m\]\W\e[m\]]$"
#function _update_ps1() {
    #PS1="$(powerline-shell $?)"
#}

#if [ "$TERM" != "linux" ]; then
    #PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
#fi
export  PATH=$PATH:/usr/local/texlive/2017/bin/x86_64-linux:/usr/bin/python3:/home/sun/go/bin:/home/sun/go/src:/usr/local/bin/stack
export GOPATH=/home/sun/go

