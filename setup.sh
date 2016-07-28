#!/bin/bash

for f in .??*
do
    [[ "$f" == ".git" ]] && continue
    [[ "$f" == ".DS_Store" ]] && continue

    ln -s $HOME/dotfiles/$f $HOME/$f
done

git clone git://github.com/altercation/vim-colors-solarized.git
mkdir ~/.vim 1>/dev/null 2>/dev/null
cp -pr vim-colors-solarized/colors/ ~/.vim/

