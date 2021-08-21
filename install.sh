#!/bin/bash
# File              : install.sh
# Author            : Sun Fu <cstsunfu@gmail.com>
# Date              : 21.07.2018
# Last Modified Date: 2021-08-20
# Last Modified By  : Sun Fu <cstsunfu@gmail.com>


install_config() {
    
    if [ ! -e "$HOME/.config/nvim" ];then
          mkdir -p "$HOME/.config/nvim"
    fi 
    ln -s ./init.lua $HOME/.config/nvim/init.lua
}
install_depend(){
    pip install flake8
    if [ $System == "Darwin" ];then
        brew install neovim
    elif [ $System == "Ubuntu" ]; then
        sudo apt-get install neovim
    else
        echo "Don't support install depend for your system, please install manually. "
    fi
}
install_depend
install_config
