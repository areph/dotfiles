#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

export PATH=/usr/local/bin:$PATH
export GOPATH=$HOME
export PATH=$PATH:$GOPATH/bin
export PATH=$HOME/.nodebrew/current/bin:$PATH
export PATH=$PATH:./node_modules/.bin

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi
prompt steeef

function is_exists() { type "$1" >/dev/null 2>&1; return $?; }
function is_osx() { [[ $OSTYPE == darwin* ]]; }
function is_screen_running() { [ ! -z "$STY" ]; }
function is_tmux_runnning() { [ ! -z "$TMUX" ]; }
function is_screen_or_tmux_running() { is_screen_running || is_tmux_runnning; }
function shell_has_started_interactively() { [ ! -z "$PS1" ]; }
function is_ssh_running() { [ ! -z "$SSH_CONECTION" ]; }


function peco-history-selection() {
  local tac
  if which tac > /dev/null; then
    tac="tac"
  else
    tac="tail -r"
  fi
  BUFFER=$(history -n 1 | eval $tac | awk '!a[$0]++' | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection

function tmux_automatically_attach_session()
{
  if is_screen_or_tmux_running; then
    ! is_exists 'tmux' && return 1

  else
    if shell_has_started_interactively && ! is_ssh_running; then
      if ! is_exists 'tmux'; then
        echo 'Error: tmux command not found' 2>&1
        return 1
      fi

      if tmux has-session >/dev/null 2>&1 && tmux list-sessions | grep -qE '.*]$'; then
        # detached session exists
        tmux list-sessions
        echo -n "Tmux: attach? (y/N/num) "
        read
        if [[ "$REPLY" =~ ^[Yy]$ ]] || [[ "$REPLY" == '' ]]; then
          tmux attach-session
          if [ $? -eq 0 ]; then
            echo "$(tmux -V) attached session"
            return 0
          fi
        elif [[ "$REPLY" =~ ^[0-9]+$ ]]; then
          tmux attach -t "$REPLY"
          if [ $? -eq 0 ]; then
            echo "$(tmux -V) attached session"
            return 0
          fi
        fi
      fi

      if is_osx && is_exists 'reattach-to-user-namespace'; then
        # on OS X force tmux's default command
        # to spawn a shell in the user's namespace
        tmux_config=$(cat $HOME/.tmux.conf <(echo 'set-option -g default-command "reattach-to-user-namespace -l $SHELL"'))
        tmux -f <(echo "$tmux_config") new-session && echo "$(tmux -V) created new session supported OS X"
      else
        tmux new-session && echo "tmux created new session"
      fi
    fi
  fi
}
tmux_automatically_attach_session

# rangerのサブシェルの中でrangerがネストしない設定
function ranger() {
  if [ -z "$RANGER_LEVEL" ]; then
    /usr/local/bin/ranger $@
  else
    exit
  fi
}
# rangerで`q`で抜けた時のディレクトリにcdするスクリプト
function ranger-cd {
  tempfile="$(mktemp -t tmp.XXXXXX)"
  /usr/local/bin/ranger --choosedir="$tempfile" "${@:-$(pwd)}"
  test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
      cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}

function agvim () {
  local selected=$(ag $@ | peco --query "$LBUFFER" | awk -F : '{print "-c " $2 " " $1}')

  if [ -n "$selected" ]; then
    local buf='vim '$selected
    eval $buf
  fi
}

export GOPATH="$HOME/.go"
export PATH=$PATH:$HOME/.go/bin

## Alias settings
alias ll='ls -la'
alias la='ls -a'

# Git
alias gs='git status'
alias gst='git status'
alias gcm='git ci -m'
alias gcim='git ci -m'
alias ga='git add -A'
alias gpl='git pull'
alias gpl='git pull'
alias less='less -r'

alias rors='rails server -b 0.0.0.0'

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"

export EDITOR=vim

setopt extended_history

alias r='ranger'
alias rc='ranger-cd'
alias b='bundle exec'
alias brb='b rake db:rollback'
alias brm='b rake db:migrate'
alias brs='b rake db:migrate:reset'
alias ag='ag -S --stats --pager "less -F"'

cd(){
  # 引数ありのときはそのままビルトインをコール
  if [ $# -gt 0 ]; then
    builtin cd "$@"
    return
  fi

  # 引数無しでプロジェクトディレクトリの中にいるときはプロジェクトルートに移動
  local gitroot=`git rev-parse --show-toplevel 2>/dev/null`
  if [ ! "$gitroot" = "" ]; then
    builtin cd "$gitroot"
    return
  fi

  # それ以外はそのままビルトインをコール
  builtin cd
}

function peco-ghq-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-ghq-src
bindkey '^[' peco-ghq-src

function peco-ghq-hub () {
  local selected_dir=$(ghq list | peco --query "$LBUFFER" | cut -d "/" -f 2,3)
  if [ -n "$selected_dir" ]; then
    BUFFER="hub browse ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-ghq-hub
bindkey '^]' peco-ghq-hub

alias ctags="`brew --prefix`/bin/ctags"
