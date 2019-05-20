#!/bin/bash

ANYENV_ROOT=$HOME/.anyenv

# set up anyenv
function setup_anyenv {
  git clone https://github.com/riywo/anyenv.git $ANYENV_ROOT
  mkdir $ANYENV_ROOT/plugins
  git clone https://github.com/znz/anyenv-update.git $ANYENV_ROOT/plugins/anyenv-update
  $ANYENV_ROOT/bin/anyenv install --init
}

setup_anyenv
