#!/bin/bash

USAGE()
{
    echo
    echo Usage..
    echo
    echo "    `basename $0` name [cmd [args]]"
    echo
    exit
}

[ $# -lt 1 ] && USAGE

NAME=screen_$1_`now -nc`
shift

case `hostname` in
    RB-EL*)
        screen -L -S $NAME $*
        ;;
    *)
        screen -L -Logfile $NAME.log -S $NAME $*
        ;;
esac

