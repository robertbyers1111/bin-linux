#!/bin/bash
#
# git log with my own type of oneliner
#

doit()
{
    echo
    echo "    % git log --pretty=format:'%ai  %<(14,trunc)%an  %h  %<|(155,trunc)%s' -32 $1 $*"
    echo
    git log --pretty=format:'%ai  %<(14,trunc)%an  %h  %<|(155,trunc)%s' -32 $1 $*
}

case $1 in
    --graph|-g|g) GRAPH=--graph
    shift
    ;;
    *) [ $# -gt 0 ] && {
        echo
        echo "USAGE: `basename $0` [--graph|-g|g]"
        echo
        echo "   FWIW, this script uses the following form of 'git log'.."
        echo
        echo "        git log --pretty=format:'%ai  %<(14,trunc)%an  %h  %<|(155,trunc)%s' -32k"
        echo
        echo "        ai - timestamp of the commit"
        echo "        an - commit author's name"
        echo "         h - hash of the commit"
        echo "         s - string of the commit message"
        echo
        exit
    }
    ;;
esac

doit $GRAPH $*

