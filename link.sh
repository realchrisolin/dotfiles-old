########################################################
# vim:smd:ar:si:noet:bg=dark:sts=0:ts=4:sw=4
# file: link.sh
# author: Chris Olin - http://chrisolin.com
# purpose: create symlinks in ~ for all files in branch
# created date: 06-26-2013
# last modified: Tue 29 Oct 2013 12:54:04 PM EDT
# license:
########################################################
#!/bin/bash

SRC=`pwd`

if [ ! -d vim-git-aware ] ; then
    git submodule init
fi

git submodule update

for i in `ls -1A -I .git -I link.sh`;
do
    if [ -f $HOME/$i ]; then
        mv  $HOME/$i $HOME/$i.orig
     fi
    echo "Symlinking $SRC/$i to $HOME/$i"
    ln -s $SRC/$i $HOME/$i
done
rm -rf $HOME/.git
rm $HOME/link.sh
