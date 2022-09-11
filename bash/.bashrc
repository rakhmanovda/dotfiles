# .bashrc

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}


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

        PS1+="${BCyan}\u${BBlue}@${BPurple}\h ${Purple}\W ${BRed}\$(parse_git_branch) ${Cyan}\$ ${RCol}"
}

alias ls='ls --color=auto'

export HISTCONTROL=ignoredups


# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc
