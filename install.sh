#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

# don't run 'sudo' when we're already root
SUDO=''
if (( $EUID != 0 )); then
    SUDO='sudo'
fi

usage () {
    echo 'Usage: ./install.sh [--install-packages] [destination]'
    echo '`destination` defaults to $HOME if omitted'
    exit
}

while test $# != 0
do
    case "$1" in
    -h|--help) usage ;;
    -i|--install-packages) option_install_packages=t ;;
    --) shift; break;;
    *)  usage ;;
    esac
    shift
done


install_dpkg_from_url () {
    TEMP_DEB="$(mktemp)" &&
    wget -O "$TEMP_DEB" "$1" && $SUDO dpkg -i "$TEMP_DEB"
    install_status=$?
    rm -f "$TEMP_DEB"
    if [[ "$install_status" != "0" ]]; then
        echo "Failed to install dpkg $1"
        exit 1
    fi
}

check_installed () {
    for app in "$@"
    do
        if ! command -v $app &> /dev/null
        then
            echo "$app is not installed"
            INSTALL_CHECK_FAILED=true
        fi
    done


    if [[ "$INSTALL_CHECK_FAILED" ]]; then
        exit 1
    fi
}

required_packages="curl wget zsh tmux vim git fzf delta bat"

if [[ "$option_install_packages" ]]; then
    if lsb_release -a | grep -i ubuntu; then
        arch=$(dpkg --print-architecture)
        $SUDO apt update
        $SUDO apt install wget curl -y
        install_dpkg_from_url "https://github.com/sharkdp/bat/releases/download/v0.21.0/bat_0.21.0_${arch}.deb"
        install_dpkg_from_url "https://github.com/dandavison/delta/releases/download/0.13.0/git-delta_0.13.0_${arch}.deb"

	if [[ "${arch}" == "arm64" ]]; then
	    # exa is not available for arm64
	    # https://github.com/ogham/exa/issues/414
            $SUDO apt-get install zsh tmux vim git fzf -y
	else
            $SUDO apt-get install zsh tmux vim git fzf exa -y
	fi
    else
        brew install zsh tmux vim fzf git-delta bat exa
    fi
fi

check_installed $required_packages

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
ln -s "$DIR/.p10k.zsh" "$INSTALL_DIR/.p10k.zsh"

ln -s "$DIR/.fzf-dynamic-preview" "$INSTALL_DIR/.fzf-dynamic-preview"

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

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins


########################
# git setup
########################
git config --global include.path "$DIR/.gitconfig"

########################
# wrap up
########################

echo "${bold}Make sure you change your shell to zsh: chsh -s $(which zsh)${normal}"
echo "${bold}Or if already using zsh, source ~/.zshrc${normal}"
