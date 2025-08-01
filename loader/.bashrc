# .bashrc loader
load_file () {
    test -f "$1" && source "$1"
}

# Load original .bashrc file (should be replaced with this .bashrc)
load_file "$HOME/.bashrc~"
load_file "$HOME/.bashrc.dotfiles"
load_file "$HOME/.bashrc.local"