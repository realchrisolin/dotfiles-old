########################################################
# vim:smd:ar:si:et:bg=dark:ts=4:sw=4
# file: .zshrc
# author: Chris Olin - http://chrisolin.com
# purpose: 
# created date: 03-18-2013
# license:
########################################################
autoload -U colors
autoload -U promptinit 
autoload -U compinit
colors
promptinit
compinit 

# source antigen and load oh-my-zsh
if [ -f "${HOME}/.antigen/antigen.zsh" ]; then
    source ~/.antigen/antigen.zsh
else
    git clone https://github.com/zsh-users/antigen.git ~/.antigen
    source ~/.antigen/antigen.zsh
fi
   
antigen-use oh-my-zsh #this is what makes zsh take forever to start, but we need it to use the following theme

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

# syntax highlighting bundle
antigen-bundle zsh-users/zsh-syntax-highlighting

# apply settings
antigen-apply

# autocompletion with arrow key interface
 zstyle ':completion:*' menu select

# autocompletion of command line switches for aliases
 setopt completealiases

#autoconfigure ssh-agent
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
     setopt local_options extended_glob
     echo "Initialising new SSH agent..."
     /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
     echo succeeded
     chmod 600 "${SSH_ENV}"
     . "${SSH_ENV}" > /dev/null
     ssh-add
     ssh-add $HOME/.ssh/keys/*[!.pub];
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
unset AUTO_NAME_DIRS
export PATH=$HOME/bin:$PATH:/usr/local/bin
export TERM=xterm-256color
export SCREENDIR=/tmp/uscreens/S-$USERNAME
export EDITOR=vim
#export TNL_SERVER=bh.sc4.proofpoint.com
#cd $HOME #this sets the CWD to $HOME so it doesn't default to My Documents
