# .zshrc
# Function definition style: function func_name { ... }

#######################################
# Constants (used only in .zshrc)
LOCAL_ZSHRC="$HOME/.zshrc.local"
# SSH_AGENT_SOCK: SSH_AUTH_SOCKをここで指定したファイル名に固定する
SSH_AGENT_SOCK="$HOME/.ssh/ssh-agent.sock"
# SSH_DEFAULT_{PREFIX,LIST}: SSH Agentに鍵が1つもない場合探すファイルのプレフィックスとファイル名リスト
SSH_DEFAULT_PREFIX="$HOME/.ssh/id_"
SSH_DEFAULT_LIST=(ed25519 ecdsa rsa)

#######################################
# Functions / aliases
function has () {
  which "$1" >/dev/null 2>&1
}

#######################################
# 環境変数、基本設定
function chlng {
  NEW_LANG=${1:-C}
  export LANG=$NEW_LANG
  export LANGUAGE=$NEW_LANG
  export LC=ALL=$NEW_LANG
  echo "Language changed to $NEW_LANG"
}

function path_include {
  local var_name=$1
  local var_value=$(eval echo '$'$var_name)
  local target=$2
  test "$(echo $var_value | grep '\(^\|:\)'"$target"'\($\|:\)')"
}

function add_env_path {
  local name=$1
  local add_value=$2
  local org_value=$(eval echo '$'$name)

  path_include "$name" "$add_value" && return

  if [ -z "$org_value" ] ; then
    export $name="$add_value"
  else
    export $name="$add_value:$org_value"
  fi
}

alias lang-en="chlng en_US.UTF-8"
alias lang-ja="chlng ja_JP.UTF-8"

if [ "$TERM" = "linux" ] ; then
  lang-en >/dev/null
else
  lang-ja >/dev/null
fi

# 色を使用できるようにする
autoload -Uz colors
colors

export ZPLUG_HOME=$HOME/.zsh/zplug

export PATH="$HOME/bin:$HOME/usr/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin"
if [ "$(uname)" = 'Darwin' ]; then
  add_env_path PATH "/Library/TeX/texbin"
fi

add_env_path LD_LIBRARY_PATH "$HOME/usr/lib"

add_env_path MANPATH ":"
add_env_path MANPATH "$HOME/usr/share/man"

has vim && export EDITOR=vim

#######################################
# zplug
if [ ! -d $ZPLUG_HOME ]; then
  mkdir -p $ZPLUG_HOME
  git clone https://github.com/zplug/zplug $ZPLUG_HOME
fi

source $ZPLUG_HOME/init.zsh

has gawk || \
  echo "gawk is not installed. Unknown error may happen in the installation process executed next." >&2

# zplug plugins list
zplug "zplug/zplug"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search"
zplug "docker/compose", use:contrib/completion/zsh

# install zplug plugins
if ! zplug check --verbose; then
  printf 'Install? [y/N]: '
  if read -q; then
    echo; zplug install
  fi
fi

# load zplug plugins
zplug load

#######################################
# その他個人設定

# ヒストリファイルの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# プロンプト
function colored-prompt () {
  PROMPT='[%F{010}%n@%m%f: %F{006}%~%f]
%(!,#,$) '
}

function non-colored-prompt () {
  PROMPT='[%n@%m: %~]
%(!,#,$) '
}

colored-prompt
PROMPT2='[%n]%_>'

# Show Git repository status
# https://qiita.com/nishina555/items/f4f1ddc6ed7b0b296825
function rprompt-git-current-branch {
  local branch_name st branch_status

  git status 2>&1 | head -n1 | grep 'On branch' >/dev/null 2>&1
  if [ "$?" != 0 ]; then
    # gitで管理されていないディレクトリは何も返さない
    return
  fi
  branch_name=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
  st=$(git status 2> /dev/null)
  if [ "$(echo "$st" | grep "^nothing to")" ]; then
    # 全てcommitされてクリーンな状態
    branch_status="%F{green}"
  elif [ "$(echo "$st" | grep "^Untracked files")" ]; then
    # gitに管理されていないファイルがある状態
    branch_status="%F{cyan}?"
  elif [ "$(echo "$st" | grep "^Changes not staged for commit")" ]; then
    # git addされていないファイルがある状態
    branch_status="%F{magenta}+"
  elif [ "$(echo "$st" | grep "^Changes to be committed")" ]; then
    # git commitされていないファイルがある状態
    branch_status="%F{yellow}!"
  elif [ "$(echo "$st" | grep "^rebase in progress")" ]; then
    # コンフリクトが起こった状態
    echo "%F{red}!(no branch)"
    return
  else
    # 上記以外の状態の場合は青色で表示させる
    branch_status="%F{blue}"
  fi
  # ブランチ名を色付きで表示する
  echo "${branch_status}[$branch_name]%{${reset_color}%}"
}

function date-with-status-color {
  echo "%(?.%{${fg[green]}%}.%{${fg[red]}%})"$(date +%T)"%{${reset_color}%}"
}

setopt prompt_subst
RPROMPT='$(date-with-status-color) $(rprompt-git-current-branch)'

# additional zplug pluins settings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down

#######################################
# 補完
# 補完機能を有効にする
autoload -Uz compinit
compinit

# 大小関係なく補完
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
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

# Completion function for sudo.vim (e.g. vim sudo:/path/to/file)
# ref: https://www.yuuan.net/item/736
function _vimsudo {
  local LAST="${words[$#words[*]]}"
  case "${LAST}" in
    sudo:*)
      local BASEDIR="${LAST##sudo:}"
      BASEDIR="${~BASEDIR}"
      [ -d "${BASEDIR}" ] && BASEDIR="${BASEDIR%%/}/"
      compadd -P 'sudo:' -f $(print ${BASEDIR}*) \
      && return 0
      ;;
    *)
      _vim && return 0
      ;;
  esac

  return 1
}

compdef _vimsudo vim

#######################################
# オプション

# 日本語ファイル名の表示
setopt print_eight_bit

# ビープ音の無効化
setopt no_beep

# Ctrl+S, Ctrl+Qによるフローコントロールの無効化
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

# historyコマンドは履歴に登録しない
setopt hist_no_store

# 余分な空白は詰めて記録
setopt hist_reduce_blanks

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
# その他設定

# 入力候補でも色をつける
zstyle ':completion:*' verbose yes
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

#######################################
# エイリアス

if [ "$(uname)" = 'Darwin' ]; then
  alias ls='ls -G'
else
  alias ls='ls --color=auto'
fi
alias ll='ls -l'
alias la='ls -la'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias mkdir='mkdir -p'
alias grep='grep --color=auto'

# sudo コマンドの後のコマンドでエイリアスを有効にする
alias sudo='sudo '

# グローバルエイリアス
alias -g L='| less'
alias -g G='| grep'

alias vim='vim -p'
alias df='df -h'

alias rsync-ssh='rsync -av -e ssh --progress --partial --append'
alias mkvenv='python -m venv --prompt $(basename $PWD) venv'

# "C" で標準出力をクリップボードにコピーする
# http://mollifier.hatenablog.com/entry/20100317/p1
if has pbcopy ; then
  # Mac
  alias -g C='| pbcopy'
elif has xsel ; then
  # Linux
  alias -g C='| xsel --input --clipboard'
elif has putclip ; then
  # Cygwin
  alias -g C='| putclip'
fi

bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line
bindkey "${terminfo[kdch1]}" delete-char
bindkey "^[[Z" reverse-menu-complete

# anyenv initialization
if [ -d $HOME/.anyenv ] ; then
  add_env_path PATH "$HOME/.anyenv/bin"
  eval "$(anyenv init -)"
fi

# rubygem initialization
if has ruby && has gem; then
  add_env_path PATH "$(ruby -rrubygems -e 'puts Gem.user_dir')/bin"
fi

function ssh {
  if [ "$(ps -p $(ps -p $$ -o ppid=) -o comm=)" = "tmux" ] ; then
    tmux rename-window "[ssh]${@: -1}"
    command ssh "$@"
    tmux set-window-option automatic-rename "on" >/dev/null
  else
    command ssh "$@"
  fi
}

# other settings for mac
if [ "$(uname)" = 'Darwin' ]; then
  export CLICOLOR=1
  export LSCOLORS=GxFxcxdxCxegedabagacad
  alias dnscacheclear="sudo killall -HUP mDNSResponder"
  alias restart-touchbar="killall ControlStrip && killall BetterTouchTool; \
                          sleep 1 && open /Applications/ツール/BetterTouchTool.app"
  alias chrome='open -a "/Applications/Google Chrome.app"'
  alias code='open -a "/Applications/Visual Studio Code.app"'
  bindkey "^[OH" beginning-of-line
  bindkey "^[OF" end-of-line
  bindkey "^[[H" beginning-of-line
  bindkey "^[[F" end-of-line
fi

if [ "$(uname)" = 'Linux' ]; then
  bindkey "^[[H" beginning-of-line
  bindkey "^[[F" end-of-line
  bindkey "^[[1~" beginning-of-line
  bindkey "^[[4~" end-of-line
fi

# Control zsh history
# If the function returns 0, the command will be added to the history file.
# Otherwise, the command will not be added.
# ref: http://mollifier.hatenablog.com/entry/20090728/p1
# ref: http://someneat.hatenablog.jp/entry/2017/07/25/073428
__record_command() {
  typeset -g _LASTCMD=${1%%$'\n'}
  return 1
}
zshaddhistory_functions+=(__record_command)

__update_history() {
  local last_status="$?"

  # hist_ignore_space
  if [[ ! -n ${_LASTCMD%% *} ]]; then
    return
  fi

  # hist_reduce_blanks
  local cmd_reduce_blanks=$(echo ${_LASTCMD} | tr -s ' ')

  # ignore commands
  local line=${_LASTCMD%%$'\n'}
  local cmd=${line%% *}

  # 以下の条件をすべて満たすものだけをヒストリに追加する
  if [ ${#line} -ge 5 -a ! -z "$(echo ${line} | grep -E '^(l[sal]|cd|man|git (add|commit|((checkout|co)( -b)?|branch) [A-Za-z/-]+))( |$)')" ]; then
    return
  fi

  print -sr -- "${cmd_reduce_blanks}"
}
precmd_functions+=(__update_history)

# SSH Agent
if [ "$(uname)" = "Linux" ] && has ssh-agent; then
  if [ -S "$SSH_AUTH_SOCK" ] ; then
    # すでにSSH Agentへのソケットが環境変数にあるがデフォルトのランダム形式の場合
    case $SSH_AUTH_SOCK in
      /tmp/*/agent.[0-9]*)
        ln -sf "$SSH_AUTH_SOCK" $SSH_AGENT_SOCK && export SSH_AUTH_SOCK=$SSH_AGENT_SOCK
        ;;
    esac
  elif [ -S "$SSH_AGENT_SOCK" ] ; then
    # すでにSSH_AGENT_SOCKがソケットへのシンボリックリンクとして存在する場合
    export SSH_AUTH_SOCK=$SSH_AGENT_SOCK
  else
    # SSH Agentが起動していない場合
    eval $(ssh-agent) && \
      ln -sf "$SSH_AUTH_SOCK" $SSH_AGENT_SOCK && \
      export SSH_AUTH_SOCK=$SSH_AGENT_SOCK
  fi
  # Kill unused ssh-agent process
  ssh_agent_real_path=$(readlink $SSH_AUTH_SOCK)
  ssh_agent_pid=$(expr 1 + ${ssh_agent_real_path##*.})
  for agent in $(ps aux | grep -E '(ssh)-agent' | awk '{ print $1"@"$2 }')
  do
    user=$(echo "${agent/@/ }" | awk '{ print $1 }')
    pid=$(echo "${agent/@/ }" | awk '{ print $2 }')
    if [ "$USER" = "$user" -a "$ssh_agent_pid" != "$pid" ] ; then
      kill $pid
      echo "Killed PID $pid (unused ssh-agent)"
    fi
  done
  for ssh_type in $SSH_DEFAULT_LIST
  do
    ident_file=$SSH_DEFAULT_PREFIX$ssh_type
    if [ -f "$ident_file" -a $(ssh-add -l 2>&1 | grep 'no identities' >/dev/null; echo $?) = 0 ] ; then
      ssh-add "$ident_file"
    fi
  done
fi

#######################################
# User defined functions
function mcd () {
  mkdir -p "$1" && cd "$1"
}

_mcd() {
  _path_files -/
}
compdef _mcd mcd

function title () {
  if [ "$TMUX" ]; then
    tmux rename-window "$@"
  else
    echo -ne "\033]0;$@\007"
  fi
}

function color_test () {
  for c in {000..255}
  do
    echo -n "\e[38;5;${c}m $c"
    [ $(($c%16)) -eq 15 ] && echo
  done
  echo
}

# tmux shortcut from https://www.ebiebievidence.com/posts/tmux-ls-attach-new-alias/
# Improved by takaion
t () {
  local opt=
  local session=
  while [ $# -gt 1 ]
  do
    test -z "$opt" && opt=$1 || opt="$opt $1"
    shift
  done
  session=$1
  tmux attach ${=opt} -t "$session" 2> /dev/null \
    || tmux new ${=opt} -s "$session" 2> /dev/null \
    || tmux ls
}

_t() { _values 'sessions' "${(@f)$(tmux ls -F '#S' 2>/dev/null )}" }
compdef _t t

if has pip; then
  function pip-update () {
    pip list --outdated --format=columns | tail -n+3 | awk '{print $1}' | xargs pip install -U pip
  }
fi

# Args: src dst
function replace_with_symlink () {
  rsync -av --sparse --progress $1 $2 && \
    rm -f $1 && \
    ln -s $2 $1
}

#######################################

# Load local zshrc
if [ -f $LOCAL_ZSHRC ]; then
  source $LOCAL_ZSHRC
fi

# Disable focus/de-focus event
printf "\e[?1004l"
