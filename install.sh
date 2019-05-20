#!/bin/bash

SCRIPT_DIR=$(dirname $0)/scripts

function make_symlink {
  local target_files=(.bashrc .gitconfig .gitignore_global .tmux.conf .vimrc .zshrc)
  local from_dir="$(dirname $0)"
  local to_dir="$HOME"

  for f in "${target_files[@]}"; do
    from="$from_dir/$f"
    to="$to_dir/$f"
    if [ -h "$to" ] ; then
      rm -f "$to"
    elif [ -e "$to" ] ; then
      mv $to "${to}.old"
      echo "Backed up $to"
    fi
    ln -s $from $to
  done
}

make_symlink
$SCRIPT_DIR/setup_anyenv.sh
