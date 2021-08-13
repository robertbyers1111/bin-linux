#!/bin/bash

[ $# -eq 1 ] && { NAME_TO_CHECK=$1; } || { NAME_TO_CHECK="^PATH$"; }

for WORD in `env | sort -V`
do
    echo $WORD | grep -q =
    [ $? -eq 0 ] && {
        NAME="`echo $WORD | cut -d= -f1`"
        echo $NAME | grep -iq "$NAME_TO_CHECK"
        [ $? -eq 0 ] && {
            echo
            # The grep is to get colorization
            echo [$NAME] | grep --color=auto -E ".*"
            eval VAL_TO_CHECK=\$$NAME
            echo $VAL_TO_CHECK | tr : '\n'
        }
    }
done

