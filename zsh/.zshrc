##
## PERSONAL INFORMATION
##

export NAME='Jarrett Cruger'
export EMAIL='jcrugzz@gmail.com'

##
## COLORING & THEMES
##

export ZSH_THEME='3rdEden'
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==34=34}:${(s.:.)LS_COLORS}")'

##
## HISTORY
##

export HISTFILE='~/.zsh_history'
export HISTFILESIZE=65536
export HISTSIZE=4096
export SAVEHIST=$HISTSIZE

##
## ALIASES & APPLICATION DEFAULTS
##

#ls
alias ls='ls --color=auto --group-directories-first --classify --human-readable'
alias ll='ls --color=auto --group-directories-first --classify --human-readable -l'
alias la='ls --color=auto --group-directories-first --classify --human-readable -l --almost-all'

# cp/mv/rm
alias cp='nocorrect cp -i'
alias mv='nocorrect mv -i'
alias rm='nocorrect rm -i'

export EDITOR=vim
export GREP_OPTIONS='--color=auto --exclude="*.pyc" --exclude-dir=".svn" --exclude-dir=".hg" --exclude-dir=".bzr" --exclude-dir=".git"'

##
## OH MY ZSH CONFIGURATIONS
##

ZSH=$HOME/.oh-my-zsh
DISABLE_AUTO_UPDATE="true"
plugins=(git github node npm osx history-substring-search.zsh tmux)
source $ZSH/oh-my-zsh.sh

##
## Open in Sublime
##
alias sub='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'

##
## Mirrors of the npm registries
##
alias enpm='npm --registry http://registry.npmjs.eu'
alias npmjitsu='npm --registry https://us.registry.nodejitsu.com'


## Functions until this can be sourced properly

#
# Sets colors based on tput or other terminal coloring
#
function set_colors() {
  if tput setaf 1 &> /dev/null; then
    tput sgr0
    if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
      RED=$(tput setaf 9)
      ORANGE=$(tput setaf 172)
      YELLOW=$(tput setaf 190)
      PURPLE=$(tput setaf 141)
      WHITE=$(tput setaf 256)
    else
      RED=$(tput setaf 5)
      ORANGE=$(tput setaf 4)
      YELLOW=$(tput setaf 2)
      PURPLE=$(tput setaf 1)
      WHITE=$(tput setaf 7)
    fi
    BOLD=$(tput bold)
    RESET=$(tput sgr0)
  else
    RED="\033[1;31m"
    ORANGE="\033[1;33m"
    YELLOW="\033[1;32m"
    PURPLE="\033[1;35m"
    WHITE="\033[1;37m"
    BOLD=""
    RESET="\033[m"
  fi
}

function parse_git_dirty() {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working directory clean" ]] && echo "*"
}

function parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

#
# fn_exists (fn)
# Returns a value determining if the function fn exists.
#
function fn_exists () {
  type $1 | grep -q 'shell function'
}

#
# echoc (msg color)
# Echos the msg with the specified color
#
function echoc () {
  msg=$1
  color=$2
  [ -z $color ] && color=$PURPLE || color=${!color}
  [ ! -z $color ] || color=$PURPLE
  echo "$color$msg$RESET"
}

#
# run(@)
# Runs `cmd` unless -d (i.e. DRY_RUN) is set.
#
function run () {
  echoc "$*"
  if [ -z $DRY_RUN ]; then
    "$@"
  fi
}

#
# nev (@)
# Evaluates the specified arguments to `node`
#
function nev() { node -pe "$@"; }

##
## PATH
##
export PATH=/usr/local/bin:/usr/local/sbin:/opt/bin:/opt/local/bin:/opt/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:/Users/jcruger/.scripts:$PATH

# Load ~/.bash_prompt, ~/.exports, ~/.aliases, ~/.functions and ~/.extra
# ~/.extra can be used for settings you don’t want to commit
for file in ~/.{exports,aliases,functions,extra,private}; do
  [ -r "$file" ] && source "$file"
done
unset file

##
## Load NVM, should be done after PATH changes
## 
export NVM_DIR="/Users/jcruger/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm use v0.10
