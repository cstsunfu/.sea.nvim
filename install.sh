#!/bin/bash
# File              : install.sh
# Author            : Sun Fu <cstsunfu@gmail.com>
# Date              : 21.07.2018
# Last Modified Date: 2021-08-20
# Last Modified By  : Sun Fu <cstsunfu@gmail.com>

#printf "\033[32m SUCCESS \033[0m\n";
#printf "\033[33m WARNING \033[0m\n";
#printf "\033[31m ERROR \033[0m\n"

install_config() {
    
    if [ ! -e "$HOME/.config/nvim" ];then
          mkdir -p "$HOME/.config/nvim"
    fi 
    ln -s -f $PWD/init.lua $HOME/.config/nvim/init.lua
    ln -s -f $PWD/coc-settings.json $HOME/.config/nvim/coc-settings.json
    echo $System
}
install_depend(){
    pip install flake8
    if [[ "$(uname)"=="Darwin" ]];then
        brew install neovim
    elif [[ -n "$(uname -a | grep Linux | grep Microsoft )" ]]; then
        sudo apt-get install neovim
    else
        printf "\033[31m ERROR: Don't support install depend for your system(only configure for WSL & MacOS), please install manually.\033[0m\n"
    fi
}
install_depend
install_config
