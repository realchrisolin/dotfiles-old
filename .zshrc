########################################################
# vim:smd:ar:si:et:bg=dark:ts=4:sw=4
# file: .zshrc
# author: Chris Olin - https://www.chrisolin.com
# purpose: personal zshrc configuration
# created date: 03-18-2013
# license:
########################################################
# compinit is slow in cygwin, let's speed it up
# Speed up startup by only checking once a day
# if the cached .zcompdump file should be regenerated

# source aliases
if [ -f "${HOME}/.aliases" ]; then
    source "${HOME}/.aliases"
fi
if [ -f "${HOME}/.secretaliases" ]; then
    source "${HOME}/.secretaliases"
fi

# source and load the oh-my-zsh library
if [ ! -d ~/.antigen ]; then
    git clone https://github.com/zsh-users/antigen.git ~/.antigen
fi
source ~/.antigen/antigen.zsh

# antigen init
antigen init ~/.antigenrc

# apply settings
antigen apply

# set autosuggestions hotkey to ctrl+space
bindkey '^ ' autosuggest-accept

# speed up pasting, workaround from https://github.com/zsh-users/zsh-autosuggestions/issues/141
zstyle ':bracketed-paste-magic' active-widgets '.self-*'

# always load zprof for perf troubleshooting
zmodload zsh/zprof

#======= set prompt "theme" =======#
# configure prompt colors
if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
eval my_gray='$FG[237]'
eval my_orange='$FG[214]'

# git color settings
ZSH_THEME_GIT_PROMPT_PREFIX="$FG[075](branch:"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="$my_orange*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$FG[075])%{$reset_color%}"

# set prompts
PROMPT='$FG[124][%y]%{$reset_color%}%  $FG[032]%~ \
$(git_prompt_info) \
$FG[105]%(!.#.»)%{$reset_color%} '
PROMPT2='%{$fg[red]%}\ %{$reset_color%}'
RPS1='${return_code}'
#==================================#

# autocompletion with arrow key interface
zstyle ':completion:*' menu select

# autocompletion of command line switches for aliases
setopt completealiases

# set environment variables for gpg-agent
gpg_agent_info="${HOME}/.gnupg/gpg-agent-info"
if [ -f $gpg_agent_info ]
then
	    source $gpg_agent_info
	    export GPG_AGENT_INFO
	    export GPG_TTY=$(tty)
fi

# autoconfigure ssh-agent
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
     echo "Starting ssh-agent..."
     /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
     echo succeeded
     chmod 600 "${SSH_ENV}"
     . "${SSH_ENV}" > /dev/null
     /usr/bin/ssh-add;
     ssh-add $HOME/.ssh/id_*[!.pub];
}

# source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
     . "${SSH_ENV}" > /dev/null
     #ps ${SSH_AGENT_PID} doesn't work under cywgin
     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
         start_agent;
     }
else
     start_agent;
fi

#other stuff
export PATH=$PATH:/usr/local/bin:$HOME/bin
export CYGWIN="mintty winsymlinks:nativeforce"
export TERM=xterm-256color
export LANG="en_US.UTF-8"
unset GREP_OPTIONS # getting rid of that godforsaken warning message about this variable being depricated every time I use grep
