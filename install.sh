#!/bin/bash

INPUT="$1"
DEFAULT_INSTALL_DIR="$HOME"
INSTALL_DIR=${INPUT:-"$DEFAULT_INSTALL_DIR"}

CURRENT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $CURRENT

git submodule init
git submodule update

########################
# shell setup
########################

# default shell will need to be changed to zsh outside of this script
curl -L git.io/antigen > "$INSTALL_DIR/.antigen.zsh"

mv "$INSTALL_DIR/.zshrc" "$INSTALL_DIR/.zshrc.bak"
ln -s "$CURRENT/.zshrc" "$INSTALL_DIR/.zshrc"

mv "$INSTALL_DIR/.p10k.zsh" "$INSTALL_DIR/.p10k.zsh.bak"
ln -s "$CURRENT/.p10k.zsh" "$INSTALL_DIR/.p10k.zsh"

########################
# vim setup
########################
mv "$INSTALL_DIR/.vim" "$INSTALL_DIR/.vim.bak"
ln -s "$CURRENT/.vim" "$INSTALL_DIR/.vim"

mv "$INSTALL_DIR/.vimrc" "$INSTALL_DIR/.vimrc.bak"
ln -s "$CURRENT/.vimrc" "$INSTALL_DIR/.vimrc"

########################
# tmux setup
########################
mv "$INSTALL_DIR/.tmux.conf" "$INSTALL_DIR/.tmux.conf.bak"
ln -s "$CURRENT/.tmux.conf" "$INSTALL_DIR/.tmux.conf"

########################
# wrap up
########################

echo "Make sure you change your shell to zsh: chsh -s $(which zsh)"
echo "Or if already using zsh, source ~/.zshrc"
