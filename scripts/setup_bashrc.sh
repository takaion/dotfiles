#!/bin/bash

SCRIPT_DIR="$(cd $(dirname "$0"); pwd)"

replace_with_symlink () {
    local real="$1"
    local link="$2"
    if [ ! -f "$real" ]; then
        echo "Skip to create a symbolic link from $real: file does not exists or is not a normal file" >&2
        return
    fi
    if [ ! -L "$link" ]; then
        ln -bsr "$real" "$link"
        echo "Created a symbolic link: $link -> $(readlink "$link")" >&2
    else
        echo "Skip to create a symbolic link ($link): a symbolic link to $(readlink "$link")." >&2
    fi
}

replace_with_symlink "$SCRIPT_DIR/../loader/.bashrc" "$HOME/.bashrc"
replace_with_symlink "$SCRIPT_DIR/../.bashrc" "$HOME/.bashrc.dotfiles"