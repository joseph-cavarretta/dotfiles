#!/usr/bin/env zsh

# ------------------------------------------------------------
# OS DETECTION

case "$OSTYPE" in
  darwin*) OS=mac ;;
  linux*)  OS=linux ;;
  *)       OS=unknown ;;
esac


# ------------------------------------------------------------
# COLORS

export COLORTERM=truecolor

if [[ "$OS" == mac ]]; then
  # BSD ls colorizes via CLICOLOR (atom one dark palette)
  export CLICOLOR=1
  export LSCOLORS=ExFxBxDxCxegedabagacad
elif [[ "$OS" == linux ]]; then
  # GNU ls needs an explicit flag
  alias ls='ls --color=auto'
fi


# ------------------------------------------------------------
# PATH

typeset -U path PATH        # auto-dedupe entries on re-source

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[ -d "$PYENV_ROOT/bin" ] && path=("$PYENV_ROOT/bin" $path)

# user-local binaries (pipx, etc.)
[ -d "$HOME/.local/bin" ] && path+=("$HOME/.local/bin")

if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi


# ------------------------------------------------------------
# SOURCES

[ -f "$HOME/.zsh_functions" ] && source "$HOME/.zsh_functions"
[ -f "$HOME/.zsh_aliases" ] && source "$HOME/.zsh_aliases"


# ------------------------------------------------------------
# LOCAL SECRETS (not tracked in git)

[ -f "$HOME/.zsh_secrets" ] && source "$HOME/.zsh_secrets"


# ------------------------------------------------------------
# HISTORY OPTIONS

setopt EXTENDED_HISTORY       # write history in :start:elapsed;command format
setopt SHARE_HISTORY          # share history between sessions
setopt HIST_EXPIRE_DUPS_FIRST # expire duplicate events first when trimming
setopt HIST_IGNORE_DUPS       # do not record an event that was just recorded
setopt HIST_IGNORE_ALL_DUPS   # delete old recorded event if new one is a duplicate
setopt HIST_SAVE_NO_DUPS      # do not write duplicate events to the history file
setopt HIST_IGNORE_SPACE      # do not record an event starting with a space
setopt HIST_VERIFY            # do not execute immediately upon history expansion


# ------------------------------------------------------------
# AUTOCOMPLETE (cached: rebuild the dump at most once per day)

autoload -Uz compinit
_zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
mkdir -p "${_zcompdump:h}"
if [[ -f "$_zcompdump" && -z "$_zcompdump"(#qN.mh+24) ]]; then
  compinit -C -d "$_zcompdump"   # fresh dump (<24h): skip the security audit
else
  compinit -d "$_zcompdump"      # missing or stale: full init
fi
unset _zcompdump

# make completion: prioritize targets
zstyle ':completion:*:*:make:*' tag-order 'targets'


# ------------------------------------------------------------
# PROMPT

# Tell pyenv not to hijack the prompt
export VIRTUAL_ENV_DISABLE_PROMPT=yes

# Version control info (vcs_info autoload + precmd hook live in .zsh_functions)
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '%b '

setopt PROMPT_SUBST

# Build prompt
PROMPT=$'%F{green}%* %f%F{blue}%~ %f$(virtualenv_info)%F{red}${vcs_info_msg_0_}%f\n> '
