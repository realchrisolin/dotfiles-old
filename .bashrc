# User dependent .bashrc file

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# Shell Options
#
# See man bash for more options...
#
# Don't wait for job termination notification
# set -o notify
#
# Don't use ^D to exit
# set -o ignoreeof
#
# Use case-insensitive filename globbing
# shopt -s nocaseglob
#
# Make bash append rather than overwrite the history on disk
 shopt -s histappend
#
# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
# shopt -s cdspell

# Completion options
#
# These completion tuning parameters change the default behavior of bash_completion:
#
# Define to access remotely checked-out files over passwordless ssh for CVS
# COMP_CVS_REMOTE=1
#
# Define to avoid stripping description in --option=description of './configure --help'
# COMP_CONFIGURE_HINTS=1
#
# Define to avoid flattening internal contents of tar files
# COMP_TAR_INTERNAL_PATHS=1
#
# Uncomment to turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
# [[ -f /etc/bash_completion ]] && . /etc/bash_completion

# History Options
#
# Don't put duplicate lines in the history.
 export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
#
# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well
#
# Whenever displaying the prompt, write the previous line to disk
# export PROMPT_COMMAND="history -a"

##History

#Ignore space and duplicates
HISTCONTROL=ignorespace:erasedups

#Increase history size
HISTSIZE=1500
HISTFILESIZE=2000

#Save command history across multiple bash instances in screen
export PROMPT_COMMAND='history -a; history -r'

# Some people use a different file for aliases
 if [ -f "${HOME}/.bash_aliases" ]; then
   source "${HOME}/.bash_aliases"
 fi
 if [ -f "${HOME}/.secretaliases" ]; then
   source "${HOME}/.secretaliases"
 fi
#
# Some people use a different file for functions
 if [ -f "${HOME}/.bash_functions" ]; then
   source "${HOME}/.bash_functions"
 fi
 
export PATH=$PATH:/usr/local/bin:$HOME/bin
export CYGWIN=mintty winsymlinks
export TERM=xterm-256color
export SCREENDIR=/tmp/uscreens/S-$USERNAME
export ANDROID_NDK=/usr/bin/android-ndk-r8b
export TTYNAME=`tty|cut -b 6-` #we need this for my custom prompt
export PS1="\[\e]0;\w\a\]\n\[\e[32m\]chris@work \[\e[33m\]($TTYNAME) \w\[\e[0m\] " #this replaces my prompt with something more pleasant on the eyes. 
export DISPLAY=:0 #this is for CygwinX/xclip
