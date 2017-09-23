#!/bin/bash
function ask()
{
    while true; do
        read -p "$2" choice
        case $choice in
            [Yy]* )
                declare -g "$1=true"
                break;
                ;;
            [Nn]* )
                declare -g "$1=false"
                break;
                ;;
            *)
                echo "Please enter y or n"
                ;;
        esac
    done
}

ask UPGRADE "Update & upgrade every thing? (y/n): "
ask DOTFILE "Using Modified Dotfile? [including tons of plugins] (y/n): "
ask CTF "Deploy CTF environment? (y/n): "

if $UPGRADE; then
    echo "Updating & Upgrading....."
    echo ============================
    sudo apt-get update
    sudo apt-get -y upgrade
    sudo apt-get -y dist-upgrade
    sudo apt-get -y autoremove
fi

if $DOTFILE; then
    echo "Deploying Dotfile & Installing plugins......"
    echo ===============================================
    sudo apt-get install -y build-essential cmake python-dev python-setuptools git bash-completion
    sudo easy_install pip
    #Overwrite Dotfile
    cp ./.bashrc ~/
    cp ./.vimrc ~/
    cp ./.tmux.conf ~/
    cp ./.screenrc ~/
    cp ./.gdbinit ~/
    #Compile vim from source
    sudo apt-get install -y libncurses5-dev libgnome2-dev libgnomeui-dev \
    libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
    libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
    python3-dev ruby-dev lua5.1 lua5.1-dev libperl-dev git
    sudo apt-get remove -y vim vim-runtime
    cd ~/
    git clone https://github.com/vim/vim.git
    cd ~/vim/
    ./configure --with-features=huge \
            --enable-multibyte \
            --enable-rubyinterp \
            --enable-pythoninterp \
            --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
            --enable-python3interp \
            --with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu \
            --enable-perlinterp \
            --enable-luainterp \
            --enable-gui=gtk2 --enable-cscope --prefix=/usr \
    sudo make VIMRUNTIMEDIR=/usr/share/vim/vim80
    sudo make install
    sudo apt-get install -y vim-runtime
    sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 1
    sudo update-alternatives --set editor /usr/bin/vim
    sudo update-alternatives --install /usr/bin/vi vi /usr/bin/vim 1
    sudo update-alternatives --set vi /usr/bin/vim
    #Install POWERLINE
    sudo apt-get install -y powerline
    #Install powerline-status
    sudo pip install powerline-status
    #Install vim plugins
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim/
    vim +PluginInstall +qall
    #Install tmux-memory-status
    git clone https://github.com/racterub/tmux-mem-cpu-load.git ~/.tmux
    cd ~/.tmux/
    cmake .
    sudo make
    sudo make install


    #cp -r .tmux/ ~/
    #cd ~/.tmux/vendor/tmux-mem-cpu-load/
    #sudo make
    #sudo make install
fi

if $CTF; then
    echo "Deploying CTF environment...."
    echo ================================
    #Install multi-arch
    sudo dpkg --add-architecture i386
    sudo apt-get update
    sudo apt-get install -y gcc-multilib
    #Install angr
    sudo apt-get install python-dev libffi-dev build-essential virtualenvwrapper
    sudo pip install angr --upgrade
    #Install binwalk
    sudo apt-get install -y binwalk
    #Install ltrace,strace,nmap
    sudo apt-get install -y nmap strace ltrace
    #Install z3
    cd ~/
    git clone https://github.com/Z3Prover/z3.git
    cd z3/
    sudo python scripts/mk_make.py --python
    cd build
    sudo make
    sudo make install
    #Install gdb & angelboy's Pwngdb, gdb-peda
    sudo apt-get install -y gdb
    cd ~/
    git clone https://github.com/scwuaptx/peda.git ~/.peda/
    git clone https://github.com/scwuaptx/Pwngdb.git ~/.pwngdb/
    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    cp ~/.peda/.inputrc ~/
    #Install pwntools
    sudo apt-get install git python-pip
    cd ~/
    git clone https://github.com/Gallopsled/pwntools.git
    cd pwntools
    sudo pip install -r requirements.txt
    cd ~/
    git clone https://github.com/aquynh/capstone.git
    cd capstone/
    ./make.sh
    sudo ./make.sh install
    #Install qira
    cd ~/
    wget -qO- https://github.com/BinaryAnalysisPlatform/qira/archive/v1.2.tar.gz | tar zx && mv qira* qira
    cd qira/
    sudo pip install -r requirements.txt
    sudo ./install.sh
    sudo ./fetchlibs.sh
fi

echo "===================================="
echo "        Installation Done           "
echo "===================================="
echo "                          - Racterub"
