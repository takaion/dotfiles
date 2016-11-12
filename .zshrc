# .zshrc

#######################################
# 環境変数、基本設定
export LANG=ja_JP.UTF-8

# 色を使用できるようにする
autoload -Uz colors
colors

# Vim 風キーバインドにする
bindkey -v

export ZPLUG_HOME=$HOME/.zsh/zplug
ZSHRC_LOCAL=~/dotfiles/.zshrc.local

export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$HOME/bin"
if [ "$(uname)" = 'Darwin' ]; then
  export PATH="$PATH:/Library/TeX/texbin"
fi

#######################################
# zplug
if [[ ! -d $ZPLUG_HOME ]]; then
    mkdir -p $ZPLUG_HOME
    git clone https://github.com/zplug/zplug $ZPLUG_HOME
fi

source $ZPLUG_HOME/init.zsh

# zplug plugins list
if [[ -z "$ZPLUG_PLUGINS_DEFINED" ]]; then
    zplug "zplug/zplug"
    zplug "themes/wedisagree", from:oh-my-zsh
    zplug "zsh-users/zsh-autosuggestions"
    zplug "zsh-users/zsh-syntax-highlighting", nice:10
    zplug "zsh-users/zsh-history-substring-search"
    zplug "mrowa44/emojify", as:command
    zplug "junegunn/fzf-bin", from:gh-r, as:command, rename-to:fzf, use:"*darwin*amd64*"
    zplug "stedolan/jq", from:gh-r, as:command, rename-to:jq
    zplug "b4b4r07/emoji-cli", on:"stedolan/jq"
fi
export ZPLUG_PLUGINS_DEFINED=1

# install zplug plugins
if ! zplug check --verbose; then
  printf 'Install? [y/N]: '
  if read -q; then
    echo; zplug install
  fi
fi

# load zplug plugins
zplug load --verbose

#######################################
# その他個人設定

# ヒストリファイルの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# プロンプト
PROMPT='[%n@%m: %~]
%(!,#,$) '

PROMPT2='[%n]%_>'

export PATH="/usr/local/bin:/usr/local/sbin:$PATH"

# additional zplug pluins settings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

#######################################
# 補完
# 補完機能を有効にする
autoload -Uz compinit
compinit

# 大小関係なく補完
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを保管しない
zstyle ':completion:*' ignore-parents parent pwd ..

# sudo コマンドの後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps コメンドのプロセス名検索
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

# コマンド履歴検索
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

#######################################
# オプション

# 日本語ファイル名の表示
setopt print_eight_bit

# ビープ音の無効化
setopt no_beep

# フローコントロールの無効化
setopt no_flow_control

# Ctrl-D で zsh を終了しない
setopt ignore_eof

# ディレクトリ名だけでcdする
setopt auto_cd

# 同時に起動したzsh間でヒストリを共有する
setopt share_history

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# 高機能なワイルドカード展開を使用する
setopt extended_glob

# コマンド訂正
setopt correct

# 詰めて表示
setopt list_packed

# 移動したディレクトリを記憶
setopt auto_pushd

# =以降も補完する(--prefix=/usrなど)
setopt magic_equal_subst

#######################################
# エイリアス

alias ll='ls -l'
alias la='ls -la'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias mkdir='mkdir -p'
alias du='du -h'
alias df='df -h'

# sudo コマンドの後のコマンドでエイリアスを有効にする
alias sudo='sudo '

# グローバルエイリアス
alias -g L='| less'
alias -g G='| grep'

alias vim='vim -p'

# 拡張子に応じて自動実行するエイリアス
# http://news.mynavi.jp/column/zsh/016/
for target in java c h cpp txt xml log
do
    alias -s ${target}=zsh_pager
done

for target in html htm xhtml
do
    alias -s ${target}=zsh_webbrowser
done

for target in jpg jpeg png gif bmp
do
    alias -s ${target}=zsh_imageviewer
done

for target in mp3 m4a wav
do
    alias -s ${target}=zsh_audioplayer
done

for target in mpg mpeg avi mp4
do
    alias -s ${target}=zsh_movieplayer
done

zsh_pager()
{
    $(zsh_commandselector "${PAGER} less more cat") ${@+"$@"}
}

zsh_webbrowser()
{
    $(zsh_commandselector "open chrome firefox less") ${@+"$@"}
}

zsh_imageviewer()
{
    $(zsh_commandselector "open gthumb imageviewer display") ${@+"$@"}
}

zsh_audioplayer()
{
    $(zsh_commandselector "afplay aplay vlc totem") ${@+"$@"}
}

zsh_videoplayer()
{
    $(zsh_commandselector "open vlc totem") ${@+"$@"}
}

zsh_commandselector()
{
    for command in $(echo ${1})
    do
        if type "${command}" > /dev/null 2>&1 ; then
            echo "${command}"
            break
        fi
    done
}

# "C" で標準出力をクリップボードにコピーする
# http://mollifier.hatenablog.com/entry/20100317/p1
if which pbcopy >/dev/null 2>&1 ; then
    # Mac
    alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1 ; then
    # Linux
    alias -g C='| xsel --input --clipboard'
elif which putclip >/dev/null 2>&1 ; then
    # Cygwin
    alias -g C='| putclip'
fi

bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line
bindkey "^[[3~" delete-char

[[ -d ~/.pyenv ]] && \
    eval "$(pyenv init -)"

[[ -d ~/.rbenv ]] && \
    export PATH=${HOME}/.rbenv/bin:${PATH} && \
    eval "$(rbenv init -)"

# other settings for mac
if [ "$(uname)" = 'Darwin' ]; then
  alias dnscacheclear="sudo killall -HUP mDNSResponder"
  bindkey "^[OH" beginning-of-line
  bindkey "^[OF" end-of-line
fi

if [ "$(uname)" = 'Linux' ]; then
  bindkey "^[[H" beginning-of-line
  bindkey "^[[F" end-of-line
  bindkey "^[[1~" beginning-of-line
  bindkey "^[[4~" end-of-line
fi

if [[ -f $ZSHRC_LOCAL ]]; then
    source $ZSHRC_LOCAL
fi
