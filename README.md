# dotvim

Installation from ~

    git clone git://github.com/premonts/dotvim.git ~/.vim

Installation of submodules

    cd ~/.vim
    git submodule update --init

Create symlinks (*nix)

    ln -s ~/.vim/vimrc ~/.vimrc  


Create symlinks (Windows) from home directory

    mklink .vimrc .vim/vimrc
    mklink /d vimfiles .vim
