# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
ZSHRC_LOCAL=~/dotfiles/.zshrc.local

function ph() {
  local prompt_descriptions
  prompt_descriptions=(
    $ZSH_THEME_GIT_PROMPT_DIRTY 'dirty\tclean でない'
    $ZSH_THEME_GIT_PROMPT_UNTRACKED 'untracked\tトラックされていないファイルがある'
    $ZSH_THEME_GIT_PROMPT_CLEAN 'clean'
    $ZSH_THEME_GIT_PROMPT_ADDED 'added\t追加されたファイルがある'
    $ZSH_THEME_GIT_PROMPT_MODIFIED 'modified\t変更されたファイルがある'
    $ZSH_THEME_GIT_PROMPT_DELETED 'deleted\t削除されたファイルがある'
    $ZSH_THEME_GIT_PROMPT_RENAMED 'renamed\tファイル名が変更されたファイルがある'
    $ZSH_THEME_GIT_PROMPT_UNMERGED 'unmerged\tマージされていないファイルがある'
    $ZSH_THEME_GIT_PROMPT_AHEAD 'ahead\tmaster リポジトリよりコミットが進んでいる'
  )

  local i
  for ((i = 1; i <= $#prompt_descriptions; i += 2))
  do
    local p=$prompt_descriptions[$i]
    local d=$prompt_descriptions[$i+1]
    echo `echo $p | sed -E 's/%.| //g'` $reset_color $d
  done
}

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="wedisagree"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git ruby osx bundler brew rails emoji-clock)

# User configuration

export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$HOME/bin"
if [ "$(uname)" = 'Darwin' ]; then
  export PATH="$PATH:/Library/TeX/texbin"
fi

if [ -f $ZSH/oh-my-zsh.sh ] ; then
    source $ZSH/oh-my-zsh.sh
fi

#######################################
# 環境変数
export LANG=ja_JP.UTF-8

# 色を使用できるようにする
autoload -Uz colors
colors

# Vim 風キーバインドにする
bindkey -v

# ヒストリファイルの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# プロンプト
PROMPT='[%n@%m: %~]
%(!,#,$) '

PROMPT2='[%n]%_>'

export PATH="/usr/local/bin:/usr/local/sbin:$PATH"

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
fi

if [[ -f $ZSHRC_LOCAL ]]; then
    source $ZSHRC_LOCAL
fi
