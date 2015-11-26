# If not running interactively, don't do anything
[[ $- != *i* ]] && return

## PATH

## npm
export PATH="$PATH:$HOME/.npm-packages/bin"

## rbenv
export PATH="$HOME/.rbenv/bin:$PATH"

## pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

## subl3 as editor
export EDITOR="subl3 -w"

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

## check status of branch for uncommited changes
function get_git_status {
	local is_git=`git status 2> /dev/null`

	if [ -z "$is_git" ] ; then
		return 1
	fi

	local status=`git status 2> /dev/null | grep "nothing to commit"`

	local dirty_marker="△"

	if [ "$status" != "nothing to commit, working directory clean" ] ; then
		echo " $dirty_marker"
	fi
}

## set up PS1, PS2, and PS3
function format_prompt {
	local GREEN="\[\e[32m\]"
	local RED="\[\033[1;31m\]"
	local CYAN="\[\033[1;36m\]"
	local BLUE="\[\033[0;34m\]"
	local DIRTYYELLOW="\[\033[1;33m\]"
	local DEFAULT="\[\033[0m\]"

	export PS1="$DEFAULT[\u@\h]$CYAN\n\w$GREEN\$(get_git_branch)$DIRTYYELLOW\$(get_git_status)$RED\n> $DEFAULT"

	export PS2="$BLUE[\u@\h \W]$RED>>$DEFAULT "

	export PS3="$GREEN[\u@\h \W]$RED>>>$DEFAULT "
}

## make sure PS variables are set up

format_prompt

## make sure nvm, rbenv, pyenv, etc. are sourced

source ~/.nvm/nvm.sh

eval "$(rbenv init -)"

eval "$(pyenv init -)"