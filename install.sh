#!/bin/bash

INPUT="$1"
DEFAULT_INSTALL_DIR="$HOME"
INSTALL_DIR=${INPUT:-"$DEFAULT_INSTALL_DIR"}

SOURCE=${BASH_SOURCE[0]}
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
    DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
    SOURCE=$(readlink "$SOURCE")
      [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
cd "$DIR"

echo "Installing dotfiles from $DIR"

git submodule init
git submodule update

########################
# shell setup
########################

# default shell will need to be changed to zsh outside of this script
curl -L git.io/antigen > "$INSTALL_DIR/.antigen.zsh"

mv "$INSTALL_DIR/.zshrc" "$INSTALL_DIR/.zshrc.bak"
ln -s "$DIR/.zshrc" "$INSTALL_DIR/.zshrc"

mv "$INSTALL_DIR/.p10k.zsh" "$INSTALL_DIR/.p10k.zsh.bak"
ln -s "$DIR/.p10k.zsh" "$DIR/.p10k.zsh"

########################
# vim setup
########################
mv "$INSTALL_DIR/.vim" "$INSTALL_DIR/.vim.bak"
ln -s "$DIR/.vim" "$INSTALL_DIR/.vim"

mv "$INSTALL_DIR/.vimrc" "$INSTALL_DIR/.vimrc.bak"
ln -s "$DIR/.vimrc" "$INSTALL_DIR/.vimrc"

########################
# tmux setup
########################
mv "$INSTALL_DIR/.tmux.conf" "$INSTALL_DIR/.tmux.conf.bak"
ln -s "$DIR/.tmux.conf" "$INSTALL_DIR/.tmux.conf"

########################
# wrap up
########################

echo "Make sure you change your shell to zsh: chsh -s $(which zsh)"
echo "Or if already using zsh, source ~/.zshrc"
