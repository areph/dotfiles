#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

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

source /home/linuxbrew/.linuxbrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[[ ! -f ~/.p10k.zsh  ]] || source ~/.p10k.zsh
autoload -Uz promptinit
promptinit
prompt powerlevel10k

function fzf-history-selection() {
  BUFFER=$(history -n 1 | fzf --tac --reverse --query "$LBUFFER")
  CURSOR=$#BUFFER
}

zle -N fzf-history-selection
bindkey '^R' fzf-history-selection

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

# rangerで`q`で抜けた時のディレクトリにcdするスクリプト
function ranger-cd {
  tempfile="$(mktemp -t tmp.XXXXXX)"
  ranger --choosedir="$tempfile" "${@:-$(pwd)}"
  test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
      cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}

function agvim () {
  local selected=$(ag $@ | fzf --query "$LBUFFER" | awk -F : '{print "-c " $2 " " $1}')

  if [ -n "$selected" ]; then
    local buf='vim '$selected
    eval $buf
  fi
}

## Alias settings
alias ll='exa -l -aa -h -@ -m --icons --git --time-style=long-iso --color=automatic --group-directories-first'
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

# Vim
export EDITOR=vim
export PATH=~/vim/src/:$PATH #ビルドしたVimを使用

#setopt extended_history
setopt interactivecomments

alias r='ranger'
alias rc='ranger-cd'
alias b='bundle exec'
alias brb='b rake db:rollback'
alias brm='b rake db:migrate'
alias brs='b rake db:migrate:reset'
alias ag='ag -S --stats --pager "less -F"'

function fzf-ghq-src() {
  local selected_dir=$(ghq list -p | fzf --cycle --reverse --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N fzf-ghq-src
bindkey '^s' fzf-ghq-src

function fzf-ghq-hub() {
  local selected_dir=$(ghq list | fzf --reverse --query "$LBUFFER" | cut -d "/" -f 2,3)
  if [ -n "$selected_dir" ]; then
    BUFFER="hub browse ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N fzf-ghq-hub
bindkey '^]' fzf-ghq-hub

#alias ctags="`brew --prefix`/bin/ctags"
if type pbcopy 2>/dev/null 1>/dev/null
then
  alias pbcopy='xsel --clipboard --input'
  alias pbpaste='xsel --clipboard --output'
fi

# vimとshを切り替える
toggle-shell() {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N toggle-shell
bindkey '^Z' toggle-shell

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(direnv hook zsh)"

#export PATH="$HOME/.rbenv/bin:$PATH"
#eval "$(rbenv init - zsh)"
PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"

alias open='xdg-open'
alias git=hub

export PATH="$PATH:`yarn global bin`"

fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
autoload -U compinit
compinit -u

alias vi='vim'

# tabtab source for electron-forge package
# uninstall by removing these lines or running `tabtab uninstall electron-forge`
[[ -f /home/areph/work/ether/ganache/node_modules/tabtab/.completions/electron-forge.zsh ]] && . /home/areph/work/ether/ganache/node_modules/tabtab/.completions/electron-forge.zsh
export PATH=$PATH:/mnt/c/Windows/System32/cmd.exe
