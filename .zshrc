########################################################
# vim:smd:ar:si:et:bg=dark:ts=4:sw=4
# file: .zshrc
# author: Chris Olin - http://chrisolin.com
# purpose:
# created date: 03-18-2013
# last modified: Wed, Nov 27, 2013  3:20:31 PM
# license:
########################################################
autoload -U colors
autoload -U promptinit
autoload -U compinit
colors
promptinit
compinit

#source aliases and functions
if [ -f "${HOME}/.aliases" ]; then
    source "${HOME}/.aliases"
fi
if [ -f "${HOME}/.secretaliases" ]; then
    source "${HOME}/.secretaliases"
fi
if [ -f "${HOME}/.functions" ]; then
    source "${HOME}/.functions/*"
fi

if [ -d "$HOME/.oh-my-zsh" ]; then
    ZSH=$HOME/.oh-my-zsh #leave this alone
    source ~/.oh-my-zsh/oh-my-zsh.sh
else
    git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
    ZSH=$HOME/.oh-my-zsh
    source ~/.oh-my-zsh/oh-my-zsh.sh
fi

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

# Autocompletion with arrow key interface
 zstyle ':completion:*' menu select

# Autocompletion of command line switches for aliases
 setopt completealiases

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

key[Home]=${terminfo[khome]}

key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' ${terminfo[smkx]}
    }
    function zle-line-finish () {
        printf '%s' ${terminfo[rmkx]}
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

#set display, needed for CygwinX/xclip
export DISPLAY=:0

#autoconfigure ssh-agent
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
     echo "Initialising new SSH agent..."
     /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
     echo succeeded
     chmod 600 "${SSH_ENV}"
     . "${SSH_ENV}" > /dev/null
     /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

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
export RPROMPT='$FG[241]colin@work$FG[124][%y]%{$reset_color%}%' #custom prompt for use with oh-my-zsh af-magic theme. you'll want to change/delete this.
export PATH=$PATH:/usr/local/bin:$HOME/bin
export CYGWIN="mintty winsymlinks:native"
export TERM=xterm-256color
export SCREENDIR=/tmp/uscreens/S-$USERNAME
export EDITOR=vim
export JAVA_HOME="/cygdrive/c/ProgramFiles/Java/jdk1.8.0_25" #I set a symlink pointing ProgramFiles to Program Files under C: to fix an issue with the space in Program Files not being escaped
export CLASSPATH=$CLASSPATH:$HOME/bin
#cd $HOME #this sets the CWD to $HOME so it doesn't default to My Documents
