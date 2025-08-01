
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

export PATH=$HOME/bin:$HOME/usr/bin:$PATH
function hideusername () {
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
}
function showusername () {
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
}
