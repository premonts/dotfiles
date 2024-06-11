# dotvim

Install stow (macos)

    brew install stow


Clone repository in a folder 

    git clone git://github.com/premonts/dotfiles.git ~/git/premonts

Use stow to create symlink (make sure ~/.config/nvim doesn't exist)

    cd ~/git/premonts/dotfiles
    stow -t ~ nvim

