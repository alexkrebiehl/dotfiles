#!/bin/bash

CURRENT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $CURRENT

git submodule init
git submodule update

ln -s $CURRENT/.vim ~/.vim
ln -s $CURRENT/.vimrc ~/.vimrc

echo ". $CURRENT/.bash_prompt" >> ~/.bashrc
source ~/.bashrc
