########################################################
# vim:smd:ar:si:et:bg=dark:ts=4:sw=4
# file: .zshrc
# author: Chris Olin - http://chrisolin.com
# purpose: personal zshrc configuration
# created date: 03-18-2013
# license:
########################################################
autoload -U colors
autoload -U promptinit 
autoload -U compinit
promptinit
compinit 

# Source shell aliases and functions
source ~/.aliases
#source ~/.privatealiases
source ~/.functions/*

# Source and load the oh-my-zsh library
if [ ! -d ~/.antigen ]; then
    git clone https://github.com/zsh-users/antigen.git ~/.antigen
fi
source ~/.antigen/antigen.zsh
antigen-use oh-my-zsh

# Set theme
antigen-theme af-magic

# Syntax highlighting bundle
antigen-bundle zsh-users/zsh-syntax-highlighting

# Apply settings
antigen-apply

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

#path additions
PATH=$PATH:/home/chris/bin:/opt/android-sdk:/opt/android-sdk/tools:/opt/android-sdk/platform-tools

#gpg stuff
export CHRISGPG="F6DD6966"
export CONTACTGPG="02884713"
export EMPLOYMENTGPG="EA1B581C"
export GITHUBGPG="EF002BF9"
export WORDPRESSGPG="C03228FF"
export WORKGPG="0A0F6593"

#oh-my-zsh/af-magic theme customizations
RPROMPT='$FG[241]%n@%m $FG[124][%y]%{$reset_color%}%'

#other stuff
unsetopt NOMATCH #for android building
unsetopt AUTO_NAME_DIRS
export TERM=xterm-256color
export PYTHONPATH=/usr/local/lib/python2.7/site-packages
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
