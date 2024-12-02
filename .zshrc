# Variables
export DRIVE_PATH="''"

# Aliases
alias adhoc="cd ~/dev/adhoc"
alias drive="cd $DRIVE_PATH"

# Pyenv
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# Add colors to Terminal (atom one dark theme)
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Load version control to prompt
autoload -Uz vcs_info
precmd () {
  vcs_info
}

# Edit viretual env to prompt
export VIRTUAL_ENV_DISABLE_PROMPT=yes

function virtenv_indicator {
    if [[ -z $VIRTUAL_ENV ]] then
        psvar[1]=''
    else
        psvar[1]=${VIRTUAL_ENV##*/}
    fi
}

add-zsh-hook precmd virtenv_indicator
# add this to prompt: %(1V.(%1v).)

# Add git branch details to prompt
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST

# Build prompt
PROMPT='%F{green}%* %f%F{blue}%~ %f%(1V.(%1v) .)%F{red}${vcs_info_msg_0_}%f$ '

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/Joseph/google-cloud-sdk/path.zsh.inc' ];
then . '/Users/Joseph/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/Joe.Cavarretta/google-cloud-sdk/completion.zsh.inc' ];
then . '/Users/Joe.Cavarretta/google-cloud-sdk/completion.zsh.inc'; fi