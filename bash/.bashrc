#
# ~/.bashrc
#

PROMPT_COMMAND=__prompt_command
__prompt_command() {
	local EXIT="$?"

	PS1=""

	local RCol="\[\e[0m\]"

	local Green="\[\e[0;32m\]"
	local Cyan="\[\e[0;36m\]"
	local Purple="\[\e[0;35m\]"
	local Blue="\[\e[0;34m\]"
	local Red="\[\e[0;31m\]"

	local BGreen="\[\e[1;32m\]"
	local BCyan="\[\e[1;36m\]"
	local BPurple="\[\e[1;35m\]"
	local BBlue="\[\e[1;34m\]"
	local BRed="\[\e[1;31m\]"

	if [ $EXIT != 0 ]; then
		PS1+="${BRed}>>>${EXIT}<<<${RCol}"
	else
		PS1+="${BGreen} -> ${RCol}"
	fi

	PS1+="${BCyan}\u${BBlue}@${BPurple}\h ${Purple}\W ${Cyan}\$ ${RCol}"
} 
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias rofi-prompt='sh ~/git/dotfiles/rofi/rofi_prompt'
alias kssh="kitty +kitten ssh"
#PS1='[\u@\h \W]\$ '

export HISTCONTROL=ignoredups
export QT_QPA_PLATFORMTHEME=qt5ct

########
#ALCI
########
alias evb='sudo systemctl enable --now vboxservice.service'
