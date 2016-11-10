#!/bin/bash

filelist=(bashrc zshrc vimrc gitconfig)

for f in "${filelist[@]}"; do
    from="~/dotfiles/_$f"
    to="~/.$f"
    if [ -f "$to" ] ; then
        mv $to $to.old
    fi
    ln -s $from $to
done
