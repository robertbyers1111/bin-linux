#!/bin/bash
[ $# -eq 1 ] && { NAMES_TO_CHECK=$1; } || { NAMES_TO_CHECK="^PATH$"; }
for NAME in `env | cut -d= -f1 | grep -E "$NAMES_TO_CHECK" | sort -V`
do
    echo
    echo [$NAME] | grep --color=auto -E ".*"  # Using grep just to colorize the name
    eval VAL_TO_CHECK=\$$NAME
    echo $VAL_TO_CHECK | tr : '\n'
done
