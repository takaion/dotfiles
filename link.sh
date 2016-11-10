#!/bin/bash

filelist=(bashrc zshrc vimrc gitconfig)

for f in "${filelist[@]}"; do
    from="$HOME/dotfiles/.$f"
    to="$HOME/.$f"
    if [ -e "$to" ] ; then
        mv $to "${to}.old"
        echo "Backed up $to"
    fi
    ln -s $from $to
done
