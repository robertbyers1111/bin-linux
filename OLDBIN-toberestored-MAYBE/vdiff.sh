#!/bin/bash
egrep -A999 ^#_ $HOME/public_html/vim/vimdiff.txt
echo Press ENTER to continue..
read ANSWER
vimdiff $*

