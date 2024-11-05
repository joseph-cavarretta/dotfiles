# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

###############################################################################
#
#   HISTORY SETTINGS
#
###############################################################################

# Expand the history size
export HISTFILESIZE=10000
export HISTSIZE=500

# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace

# Causes bash to append to history instead of overwriting it so if you start a new terminal, you have old session history
shopt -s histappend
PROMPT_COMMAND='history -a'


###############################################################################
#
#   GENERAL SETTINGS
#
###############################################################################


# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make 'less' more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


###############################################################################
#
#   PROMPT SETTINGS
#
###############################################################################


# The various escape codes that color the prompt.
        RED="\[\033[0;31m\]"
     YELLOW="\[\033[0;33m\]"
      GREEN="\[\033[0;32m\]"
       BLUE="\[\033[0;34m\]"
     PURPLE="\[\033[0;35m\]"
  LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
      WHITE="\[\033[1;37m\]"
 LIGHT_GRAY="\[\033[0;37m\]"
 COLOR_NONE="\[\e[0m\]"

# determine git branch name
function parse_git_branch(){
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# determine mercurial branch name
function parse_hg_branch(){
  hg branch 2> /dev/null | awk '{print " (" $1 ")"}'
}

# Determine the branch/state information for this git repository.
function set_git_branch() {
  # Get the name of the branch.
  branch=$(parse_git_branch)
  # if not git then maybe mercurial
  if [ "$branch" == "" ]
  then
    branch=$(parse_hg_branch)
  fi

  # Set the final branch string.
  BRANCH="${RED}${branch}${COLOR_NONE}"
}

# Determine active Python virtualenv details.
function set_virtualenv () {
  if test -z "$VIRTUAL_ENV" ; then
      PYTHON_VIRTUALENV=""
  else
      PYTHON_VIRTUALENV=" ${BLUE}[`basename \"$VIRTUAL_ENV\"`]${COLOR_NONE}"
  fi
}

# Set the full bash prompt.
function set_bash_prompt () {
  # Set the PYTHON_VIRTUALENV variable.
  set_virtualenv

  # Set the BRANCH variable.
  set_git_branch

  # Set the bash prompt variable.
  PS1="${GREEN}\A ${YELLOW}\w${PYTHON_VIRTUALENV}${BRANCH} $ "
}

# Limit length of path in prompt
PROMPT_DIRTRIM=2

# Tell bash to execute this function just before displaying its prompt.
PROMPT_COMMAND=set_bash_prompt


###############################################################################
#
#   PYENV
#
###############################################################################


export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv 1>/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"


###############################################################################
#
#   FUNCTIONS
#
###############################################################################


function dotbkp () {
  # copy and push selected dotfiles to github
  
  # bash
  cp ~/.bashrc ~/dev/dotfiles/bashrc
  # vim
  cp ~/.vimrc ~/dev/dotfiles/vimrc
  cp -r ~/.vim ~/dev/dotfiles/vim
  # git
  cp ~/.gitconfig ~/dev/dotfiles/gitconfig

  cd ~/dev/dotfiles
  git add . 
  git commit -m 'dotfiles backup'
  git push
  cd ~
}


function mkrepo() {
  local name=$1
  local token=""

  curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $token" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/user/repos \
  -d \''{"name":"'"$name"'", "gitignore_template":"python", "private":true, "is_template":false}'\'
}



function newproject () {
  # execute as newproject 'dirname' 'python version'
  local dirname=$1
  local python_version=$2
  
  # navigate to projects dir
  cd ~/dev

  # create folders
  mkdir $dirname
  cd    $dirname

  mkdir 'src'
  mkdir 'tests'
  mkdir 'scripts'
  touch 'README.md'
  touch 'requirements.txt'
  
  # check for .gitignore in templates, otherwise create blank
  #if [ -f ~/dev/templates/.gitignore ]; then
  #  cp ~/dev/templates/.gitignore .gitignore
  #else 
  #  touch .gitignore
  #fi
  
  # create virtualenv
  pyenv virtualenv $python_version $dirname-$python_version
  pyenv local      $dirname-$python_version

  # initialize git
  git init
  git remote add "origin" git@github.com:joseph-cavarretta/text-wrangler.git
  #git add .
  #git commit -m "initial commit"
  #git push origin main
}


###############################################################################
#
#   ALIASES
#
###############################################################################

# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# cd aliases
alias home="cd ~"
alias dev="cd ~/dev"
alias ad-hoc="cd ~/dev/ad-hoc"
alias dotfiles="cd ~/dev/dotfiles"

# git aliases
alias gs="git status"
alias gb="git branch"

# ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# chmod aliases
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

# misc aliases
alias google="google-chrome"
alias date='date "+%Y-%m-%d %A %T %Z"'
alias ps="ps auxf"