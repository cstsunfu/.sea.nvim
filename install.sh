#!/bin/bash
# File              : install.sh
# Author            : Sun Fu <cstsunfu@gmail.com>
# Date              : 21.07.2018
# Last Modified Date: 01.07.2019
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
  System="$(uname -s)"
  if [ $System == "Darwin" ];then
    if [ ! -e "$HOME/Library/Fonts" ];then
      mkdir "$HOME/Library/Fonts"
    fi 
    cp $HOME/.local/share/fonts/* $HOME/Library/Fonts/
  else
    # 使mkfontscale和mkfontdir命令正常运行
    sudo apt-get install ttf-mscorefonts-installer
    # 使fc-cache命令正常运行
    sudo apt-get install fontconfig
    fc-cache -fv > /dev/null
    mkfontdir "$HOME/.local/share/fonts" > /dev/null
    mkfontscale "$HOME/.local/share/fonts" > /dev/null
  fi
  success "font cache done!"
}

install_config() {
    
    if [ ! -e "$HOME/.config/nvim" ];then
          mkdir -p "$HOME/.config/nvim"
    fi 
    cp init.vim $HOME/.vimrc
    cp .flake8 $HOME/.flake8
    cp init.vim $HOME/.config/nvim/init.vim
    cp -r .sunfu.vim $HOME/
}
install_depend(){
    pip install flake8
    #brew install ctags
    if [ $System == "Darwin" ];then
        brew install fontconfig
        brew install neovim
        brew install --HEAD universal-ctags/universal-ctags/universal-ctags
        brew install tmux
    else
        sudo apt-get install neovim
    fi
}
install_depend
install_fonts
install_config
