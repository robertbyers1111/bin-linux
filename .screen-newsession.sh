#!/bin/bash

[ $# -eq 0 ] && BASENAME=screen || BASENAME="$1"

NAME=${BASENAME}_`now -nc`
shift

case `hostname` in
    RB-EL7*) # For hosts running old version of screen that don't support '-Logfile'
        screen -L -S $NAME $*
        ;;
    *) # For hosts running a more modern version of screen
        screen -L -Logfile $NAME.log -S $NAME $*
        ;;
esac

