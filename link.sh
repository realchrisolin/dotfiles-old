########################################################
# vim:smd:ar:si:et:bg=dark:ts=4:sw=4
# file: link.sh
# author: Chris Olin - http://chrisolin.com
# purpose: create symlinks in ~ for all files in branch
# created date: 06-26-2013
# last modified: Wed, Jun 26, 2013  9:00:21 AM
# license:
########################################################
#!/bin/bash

SRC=`pwd`
for i in `ls -1A`;
do
    ln -s $SRC/$i $HOME/$i
done
rm -rf $HOME/.git
