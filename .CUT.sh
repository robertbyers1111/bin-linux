#!/bin/bash

[ $# -gt 1 ] && SHOW_INFO=1 || SHOW_INFO=0

while [ $# -gt 0 ]
do
    [ $SHOW_INFO -eq 1 ] && {
        echo
        echo ===== $1
    }
    [ -r "$1" ] && {
        cat "$1" | cut -c-`/usr/bin/tput cols`
    } || {
        echo WARNING: $1 is one of: not a file, not readable, not exist
    }
    shift
done

#Display a trailing blank line if there were multiple files displayed
[ $SHOW_INFO -eq 1 ] && {
    echo
}

