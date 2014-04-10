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

#Keep antigen commented out -- takes at least 20 seconds for zsh to load otherwise

# Source antigen and load oh-my-zsh
if [ -f "${HOME}/.antigen/antigen.zsh" ]; then
    source ~/.antigen/antigen.zsh
else
    git clone https://github.com/zsh-users/antigen.git ~/.antigen
    source ~/.antigen/antigen.zsh
fi
   
antigen-use oh-my-zsh #this is what makes zsh take forever to start, but we need it to use the following theme

# Set theme
antigen-theme af-magic

# Syntax highlighting bundle
 antigen-bundle zsh-users/zsh-syntax-highlighting #this makes cygwin painfully slow with a crapton of QueryFile operations. keep it commented unless you like waiting literal seconds for each charater you type to appear on your screen.

# Apply settings
antigen-apply

#Set required variables, then source and load oh-my-zsh -- grab it from git if it doesn't exist

#if [ -d "$HOME/.oh-my-zsh" ]; then
#    ZSH=$HOME/.oh-my-zsh #leave this alone
#    ZSH_THEME=af-magic #change this to whatever theme you want (`ls ~/.oh-my-zsh/themes` for a list)
#    source ~/.oh-my-zsh/oh-my-zsh.sh
#else
#    git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
#    ZSH=$HOME/.oh-my-zsh
#    ZSH_THEME=af-magic
#    source ~/.oh-my-zsh/oh-my-zsh.sh
#fi 

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

#source aliases and functions
source ~/.aliases
source ~/.workaliases
source ~/.functions/*

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
unset AUTO_NAME_DIRS
export RPROMPT='$FG[241]chris@work$FG[124][%y]%{$reset_color%}%' #custom prompt for use with oh-my-zsh af-magic theme. you'll want to change/delete this.
export PATH=$HOME/bin:$PATH:/usr/local/bin
export CYGWIN=mintty winsymlinks
export TERM=xterm-256color
export SCREENDIR=/tmp/uscreens/S-$USERNAME
export EDITOR=vim
#cd $HOME #this sets the CWD to $HOME so it doesn't default to My Documents
