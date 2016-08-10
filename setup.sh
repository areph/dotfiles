#!/bin/bash

for f in .??*
do
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue

    ln -s $HOME/dotfiles/$f $HOME/$f
done

## Other setup

## vim
# color
git clone git://github.com/altercation/vim-colors-solarized.git
cp -pr vim-colors-solarized/colors/ ~/.vim/colors/
rm -rf vim-colors-solarized

