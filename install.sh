#!/bin/bash

abs_base_dir=$(cd $(dirname $0); pwd)
BASE_DIR=${abs_base_dir#$HOME/}
SCRIPT_DIR="$BASE_DIR/scripts"

function make_symlink {
  local target_files=(.bashrc .gitconfig .gitignore_global .tmux.conf .vimrc .zshrc)
  local from_dir="$BASE_DIR"
  local to_dir="$HOME"

  for f in "${target_files[@]}"; do
    from="$from_dir/$f"
    to="$to_dir/$f"

    if [ ! -f "$from" ] ; then
      continue
    fi

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
