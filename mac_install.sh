#!/bin/bash


COLOR_RED='\033[1;31m'
COLOR_RESET='\033[0m'

if type xcode-select >&- && xpath=$( xcode-select --print-path ) &&
   test -d "${xpath}" && test -x "${xpath}" ; then
    :
else
   echo -e "${COLOR_RED}Your Xcode Command-Line tool is not installed"
   echo -e "Exiting....${COLOR_RESET}"
   exit
fi

which -s brew
if [[ $? != 0 ]] ; then
    # Install Homebrew
    echo -e "${COLOR_RED}Brew not installed${COLOR_RESET}"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    brew update
fi


echo "+==========================+"
echo "|Updating & Upgrading..... |"
echo "+==========================+"

#configs
cp ./.bashrc ~/
cp ./.vimrc ~/
cp ./.tmux.conf ~/

#Vim
brew install macvim --with-override-system-vim

#Powerline-status
sudo pip3 install powerline-status

#Vundle & Plugins
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim/
vim +PluginInstall +qall

#Tmux & Plugins
brew install tmux
git clone https://github.com/racterub/tmux-mem-cpu-load.git ~/.tmux
cd ~/.tmux/
cmake .
sudo make
sudo make install

#Virtuanenv
sudo pip3 install virtualenv virtualenvwrapper

#docker
brew cask install docker

source ~/.bashrc

echo "===================================="
echo "|        Installation Done         |"
echo "===================================="
echo "                          - Racterub"