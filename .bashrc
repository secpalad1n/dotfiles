#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

## REFERENCE

## colors
	#Black        0;30     Dark Gray     1;30
	#Red          0;31     Light Red     1;31
	#Green        0;32     Light Green   1;32
	#Brown/Orange 0;33     Yellow        1;33
	#Blue         0;34     Light Blue    1;34
	#Purple       0;35     Light Purple  1;35
	#Cyan         0;36     Light Cyan    1;36
	#Light Gray   0;37     White         1;37

## PATH

## npm
export PATH="$PATH:$HOME/.npm-packages/bin"

## rbenv
export PATH="$HOME/.rbenv/bin:$PATH"

## pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

## cuda stuff
export PATH="$PATH:/usr/local/cuda-7.0/bin"
export LD_LIBRARY_PATH=":/usr/local/cuda-7.0/lib64"
export PATH="$PATH:/usr/local/cuda-7.0/targets/x86_64-linux/include"
export LD_LIBRARY_PATH=":/usr/local/cuda-7.0/targets/x86_64-linux/lib"

if [ -z "${DISPLAY:-}" ]; then
  IS_X_RUNNING=false
  EDITOR='vim'
else
  IS_X_RUNNING=true
  EDITOR='subl3 -w'
fi

export EDITOR

## STARTUP FUNCTION TO GREET USER
function NAME_GRAPHIC {
	local RED='\033[0;31m'
	local L_PURPLE='\033[1;35m'
	local L_GREEN='\033[1;32m'
	local L_CYAN='\033[0;36m'
	local GRAY='\033[1;30m'
	local END_COLOR='\033[0m'
  local X_NAME="仙剑奇侠传"
  local NAME="palad1n"

  if [ "${IS_X_RUNNING}" == true ]; then
    printf "${GRAY}Welcome home,${END_COLOR} ${RED}${NAME}${END_COLOR}\n"
    printf "${L_CYAN}\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ ${END_COLOR}\n"
    printf "${L_PURPLE}                                                            \n"
    printf "                |             | _ |         \n"
    printf "  __ \    _\` |  |   _\` |   _\` |   |  __ \   \n"
    printf "  |   |  (   |  |  (   |  (   |   |  |   |  \n"
    printf "  .__/  \__,_| _| \__,_| \__,_|  _| _|  _|  \n"
    printf " _|                                         \n"
    printf "${END_COLOR}                                    \n"
    printf "${L_CYAN}\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ ${END_COLOR}\n"
    printf "\n"
  else
    printf "${GRAY}Welcome home,${END_COLOR} ${RED}${NAME}${END_COLOR}"
  fi
}

## ALIASES

alias ls='ls --color=auto'

alias redo='sudo $(history -p \!\!)'

## FUNCTIONS

## cd and ls
function cdl() {
	cd $1;
	ls;
}

## mkdir and cd
function mdir() {
	mkdir -p "$@" && eval cd "\"\$$#\"";
}

## git branch name
function get_git_branch {
	git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \[\1\]/'
}

## check for stash contents
function get_git_stash {
  local stash=`expr $(git stash list 2> /dev/null | wc -l)`

  if [ $stash != "0" ]; then
    echo " ∴($stash)"
  fi
}

## check status of branch for uncommited changes
function get_git_status {
	local is_git=`git status 2> /dev/null`

	if [ -z "$is_git" ] ; then
		return 1
	fi

	local status=`git status 2> /dev/null | grep "nothing to commit"`

  local untracked_status=`git status 2> /dev/null | grep "Untracked files"`

	local dirty_marker="△"

  local untracked_marker="??"

	if [ "$status" != "nothing to commit, working directory clean" ] ; then
    if [ "$untracked_status" != "Untracked files:" ]; then
      echo " $dirty_marker"
    else
      echo " $untracked_marker"
    fi
	fi
}

## set up PS1, PS2, and PS3
function format_prompt {
	local GREEN="\[\e[32m\]"
	local RED="\[\033[1;31m\]"
	local CYAN="\[\033[1;36m\]"
	local BLUE="\[\033[0;34m\]"
	local DIRTYYELLOW="\[\033[1;33m\]"
  local GRAY="\[\033[1;30m\]"
	local DEFAULT="\[\033[0m\]"

	export PS1="$DEFAULT[$GRAY\u@\h$DEFAULT]$CYAN\n\w$GREEN\$(get_git_branch)$DIRTYYELLOW\$(get_git_status)$GRAY\$(get_git_stash)\n$RED>$DEFAULT "

	export PS2="$BLUE[\u@\h \W]$RED>>$DEFAULT "

	export PS3="$GREEN[\u@\h \W]$RED>>>$DEFAULT "
}

## make sure PS variables are set up

format_prompt

## make sure nvm, rbenv, pyenv, etc. are sourced

source ~/.nvm/nvm.sh

eval "$(rbenv init -)"

eval "$(pyenv init -)"

NAME_GRAPHIC