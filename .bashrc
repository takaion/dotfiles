
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

case "${OSTYPE}" in
    darwin*)
        alias ls="ls -G"
        alias ll="ls -lG"
        alias la="ls -laG"
        ;;
    linux*)
        alias ls='ls --color'
        alias ll='ls -l --color'
        alias la='ls -la --color'
        ;;
esac

export HISTCONTROL=ignoreboth
export HISTIGNORE="fg*:bg*:history*:cd*:ls*:ll*:la*"

PS1="\u@\h: \w\$ "
