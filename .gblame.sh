#!/bin/bash

# This script displays as sorted list of all functions found in a one or more python files.
#
# USAGE: .funcs.sh file...
#

doit()
{
    [ -f $1 ] && {
         git blame $1 | cut -d\( -f2- | sed 's/\(:..:..\) [+-][0-1][0-9]00/\1/' | gvim -
    } || {
         echo ERROR: $1 not exist
    }
}

[ $# -eq 0 ] && {
    echo USAGE: `basename $0` file..
    exit
}

while [ $# -gt 0 ]; do
    doit $1
    shift
done

