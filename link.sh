#!/bin/bash

filelist=(bashrc zshrc vimrc gitconfig gitignore_global tmux.conf)

for f in "${filelist[@]}"; do
    from="$(dirname $0)/.$f"
    to="$HOME/.$f"
    if [ -e "$to" ] ; then
        mv $to "${to}.old"
        echo "Backed up $to"
    fi
    ln -s $from $to
done
