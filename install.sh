#!/bin/bash
install_config() {
    if [ ! -e "$HOME/.config/nvim" ];then
          mkdir -p "$HOME/.config/nvim"
    fi
    ln -s -f $PWD/init.lua $HOME/.config/nvim/init.lua
    ln -s -f $PWD/coc-settings.json $HOME/.config/nvim/coc-settings.json
    echo $System
}

install_config
