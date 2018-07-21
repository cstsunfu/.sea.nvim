#!/bin/bash
# File              : install.sh
# Author            : Sun Fu <cstsunfu@gmail.com>
# Date              : 21.07.2018
# Last Modified Date: 21.07.2018
# Last Modified By  : Sun Fu <cstsunfu@gmail.com>
msg() {
  printf '%b\n' "$1" >&2
}

success() {
  msg "${Green}[✔]${Color_off} ${1}${2}"
}

info() {
  msg "${Blue}[➭]${Color_off} ${1}${2}"
}

error() {
  msg "${Red}[✘]${Color_off} ${1}${2}"
  exit 1
}

warn () {
  msg "${Red}[✘]${Color_off} ${1}${2}"
}
# download_font {{{
download_font () {
  url="https://raw.githubusercontent.com/wsdjeg/DotFiles/master/local/share/fonts/$1"
  path="$HOME/.local/share/fonts/$1"
  if [[ -f "$path" ]]
  then
    success "Downloaded $1"
  else
    info "Downloading $1"
    curl -s -o "$path" "$url"
    success "Downloaded $1"
  fi
}

# }}}

# install_fonts {{{
install_fonts () {
  if [[ ! -d "$HOME/.local/share/fonts" ]]; then
    mkdir -p $HOME/.local/share/fonts
  fi
  download_font "DejaVu Sans Mono Bold Oblique for Powerline.ttf"
  download_font "DejaVu Sans Mono Bold for Powerline.ttf"
  download_font "DejaVu Sans Mono Oblique for Powerline.ttf"
  download_font "DejaVu Sans Mono for Powerline.ttf"
  download_font "DroidSansMonoForPowerlinePlusNerdFileTypesMono.otf"
  download_font "Ubuntu Mono derivative Powerline Nerd Font Complete.ttf"
  download_font "WEBDINGS.TTF"
  download_font "WINGDNG2.ttf"
  download_font "WINGDNG3.ttf"
  download_font "devicons.ttf"
  download_font "mtextra.ttf"
  download_font "symbol.ttf"
  download_font "wingding.ttf"
  info "Updating font cache, please wait ..."
  if [ $System == "Darwin" ];then
    if [ ! -e "$HOME/Library/Fonts" ];then
      mkdir "$HOME/Library/Fonts"
    fi 
    cp $HOME/.local/share/fonts/* $HOME/Library/Fonts/
  else
    fc-cache -fv > /dev/null
    mkfontdir "$HOME/.local/share/fonts" > /dev/null
    mkfontscale "$HOME/.local/share/fonts" > /dev/null
  fi
  success "font cache done!"
}

install_config() {
    
    if [ ! -e "$HOME/.config/nvim" ];then
          mkdir "$HOME/.config/nvim"
    fi 
    if [ ! -e "$HOME/.vim" ];then
          mkdir "$HOME/.vim"
    fi 
    cp init.vim $HOME/.vimrc
    cp init.vim $HOME/.config/nvim/init.vim
    rm -rf $HOME/.vim/autoload
    rm -rf $HOME/.vim/colors
    rm -rf $HOME/.vim/myplugin
    mv autoload $HOME/.vim/
    mv colors $HOME/.vim/
    mv myplugin $HOME/.vim/
}
install_depend(){
    brew install neovim
}
install_fonts
install_config
install_depend
