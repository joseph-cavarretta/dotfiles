#!/usr/bin/env zsh

# COLORS
export COLORTERM=truecolor

# SOURCES
[ -f ~/.zsh_functions ] && source ~/.zsh_functions

# HISTORY OPTIONS

# write history file in :start:elapsed;command format
setopt EXTENDED_HISTORY

# share history between sessions
setopt SHARE_HISTORY

# expire duplicate events first when trimming history
setopt HIST_EXPIRE_DUPS_FIRST

# do not record an event that was just recorded
setopt HIST_IGNORE_DUPS

# delete an old recorded event if new one is a duplicate
setopt HIST_IGNORE_ALL_DUPS

# do not write duplicate events to the history file
setopt HIST_SAVE_NO_DUPS

# do not record an event starting with a space
setopt HIST_IGNORE_SPACE

# do not execute immediately upon history expansion
setopt HIST_VERIFY

# AUTOCOMPLETE

autoload -Uz compinit
compinit

# Makefile
zstyle ':completion:*:*:make:*' tag-order 'targets'

# PYENV

export PYENV_ROOT="$HOME/.pyenv"
if [ -d "$PYENV_ROOT/bin" ]; then
  export PATH="$PYENV_ROOT/bin:$PATH"
fi

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
  if [ -d "$PYENV_ROOT/plugins/pyenv-virtualenv" ]; then
    eval "$(pyenv virtualenv-init -)"
  fi
fi

# PROMPT

# Add colors to Terminal (atom one dark theme)
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Load version control to prompt
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '%b '
autoload -Uz vcs_info

# Edit virtual env to prompt
export VIRTUAL_ENV_DISABLE_PROMPT=yes

setopt PROMPT_SUBST

# Build prompt
PROMPT=$'%F{green}%* %f%F{blue}%~ %f%(1V.(%1v) .)%F{red}${vcs_info_msg_0_}%f\n> '

# ALIASES

# dir aliases
alias home="cd ~"
alias dev="cd ~/dev"
alias ah="cd ~/dev/adhoc"
alias dot="cd ~/dev/dotfiles"

# git aliases
alias gs="git status"
alias gb="git branch"
alias ga="git add"
alias gco="git checkout"
alias gp="git pull"

# ls aliases
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"

# python aliases
alias pip-clear="pip freeze | xargs pip uninstall -y"

# misc aliases
alias cl="clear"
alias ps="ps aux"
alias ports="sudo lsof -i -P -n"
alias listen="sudo lsof -i -P -n | grep LISTEN"

