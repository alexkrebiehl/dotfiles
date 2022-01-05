#!/bin/bash

CURRENT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $CURRENT

git submodule init
git submodule update

########################
# shell setup
########################

# default shell will need to be changed to zsh outside of this script
curl -L git.io/antigen > ~/.antigen.zsh

mv ~/.zshrc ~/.zshrc.bak
ln -s $CURRENT/.zshrc ~/.zshrc

mv ~/.p10k.zsh ~/.p10k.zsh.bak
ln -s $CURRENT/.p10k.zsh ~/.p10k.zsh

########################
# vim setup
########################
mv ~/.vim ~/.vim.bak
ln -s $CURRENT/.vim ~/.vim

mv ~/.vimrc ~/.vimrc.bak
ln -s $CURRENT/.vimrc ~/.vimrc

########################
# tmux setup
########################
mv ~/.tmux.conf ~/.tmux.conf.bak
ln -s $CURRENT/.tmux.conf ~/.tmux.conf

########################
# wrap up
########################

echo "Make sure you change your shell to zsh: chsh -s $(which zsh)"
echo "Or if already using zsh, source ~/.zshrc"
