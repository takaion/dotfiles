#!/bin/bash

abs_base_dir=$(cd $(dirname $0); pwd)
BASE_DIR=${abs_base_dir#$HOME/}
SCRIPT_DIR="$BASE_DIR/scripts"

function make_symlink {
  local target_files=(.gitconfig .config/git/ignore .tmux.conf .vimrc .zshrc)
  local from_dir="$BASE_DIR"
  local to_dir="$HOME"

  echo "To set up .bashrc, run scripts/setup_bashrc.sh instead of $0" >&2

  for f in "${target_files[@]}"; do
    from="$from_dir/$f"
    to="$to_dir/$f"

    if [ ! -f "$from" ] ; then
      continue
    fi

    mkdir -p "$(dirname "$to")"

    if [ -h "$to" ] ; then
      rm -f "$to"
    elif [ -e "$to" ] ; then
      mv $to "${to}.old"
      echo "Backed up $to"
    fi
    ln -s $from $to
    echo "Make symbolic link $from (to $to)"
  done
}

make_symlink
$SCRIPT_DIR/setup_anyenv.sh
