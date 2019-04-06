#!/bin/bash

ANYENV_ROOT=$HOME/.anyenv

# set up anyenv
function setup_anyenv {
  git clone https://github.com/riywo/anyenv.git $ANYENV_ROOT
  mkdir $ANYENV_ROOT/plugins
  git clone https://github.com/znz/anyenv-update.git $ANYENV_ROOT/plugins/anyenv-update
  $ANYENV_ROOT/bin/anyenv install --init
}

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
setup_anyenv
