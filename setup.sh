#!/bin/bash

## vim
for f in .??*
do
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue

    ln -s $HOME/dotfiles/$f $HOME/$f
done

## nvim
for f in nvim/*
do
  ln -s $HOME/dotfiles/$f $HOME/.config/$f
done

## Other setup

# color
git clone git://github.com/altercation/vim-colors-solarized.git
cp -pr vim-colors-solarized/colors/ ~/.vim/colors/
rm -rf vim-colors-solarized

