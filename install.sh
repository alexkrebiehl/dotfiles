#!/bin/bash

CURRENT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $CURRENT

git submodule init
git submodule update

########################
# shell setup
########################

# RUNZSH=no and CHSH=no allows non-interactive install
# default shell will need to be changed to zsh outside of this script
ZSH= RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
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
TPM_DIR="~/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  echo "$TPM_DIR does not exist"
  mkdir -p "$TPM_DIR"
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

mv ~/.tmux.conf ~/.tmux.conf.bak
ln -s $CURRENT/.tmux.conf ~/.tmux.conf

########################
# wrap up
########################

echo "Make sure you change your shell to zsh: chsh -s $(which zsh)"
echo "Or if already using zsh, source ~/.zshrc"
