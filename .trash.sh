#!/bin/bash
YOUR_TRASH=~/.trash
[ $# -lt 1 ] && { echo USAGE: `basename $0` file... ; exit ; }
[ ! -d $YOUR_TRASH ] && { echo $YOUR_TRASH does not exist or is not a directory ; exit ; }
while [ $# -gt 0 ]; do
    [ -f "$1" ] && mv "$1" $YOUR_TRASH || echo "$1" does not exist or is not a regular file
    shift
done
