#!/bin/bash
shopt -s nocasematch

PAUSE_FILE=~/.forever/

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
USAGE() {
    echo
    echo Usage..
    echo "    `basename $0` pause_file pause|resume"
    echo
    exit
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
RequireArgCount() {
    OBSERVED_COUNT=$1
    MIN_EXPECTED=$2
    [ $# -eq 1 ] && { MIN_EXPECTED=1; MAX_EXPECTED=1; }
    [ $# -eq 2 ] && MAX_EXPECTED=$2 || MAX_EXPECTED=$3
    [ $OBSERVED_COUNT -lt $MIN_EXPECTED ] && USAGE Too few args on command line, or invalid option specified
    [ $OBSERVED_COUNT -gt $MAX_EXPECTED ] && USAGE Too many args on command line, or invalid option specified
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
doit()
{
    :
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   ***  M A I N  ***

RequireArgCount $# 2

BASE_FILENAME=$1
UNPAUSED_FILE=${BASE_FILENAME}.nopause
PAUSED_FILE=${BASE_FILENAME}.pause

[ ! -r $UNPAUSED_FILE -a ! -r $PAUSED_FILE ] && {
    echo No pause or unpause file exists
    echo Creating $PAUSED_FILE
    touch $PAUSED_FILE
}

[ ! -r $UNPAUSED_FILE -a ! -r $PAUSED_FILE ] && {
    echo ERROR: Still no pause or unpause file that either exists, is a file, or is readable
    exit
}

case "$2" in
    1|unpause|nopause|start|restart|resume) :
        [ -f $PAUSED_FILE ] && rm $PAUSED_FILE
        touch $UNPAUSED_FILE
    ;;
    0|pause|stop) :
        [ -f $UNPAUSED_FILE ] && rm $UNPAUSED_FILE
        touch $PAUSED_FILE
    ;;
    *) echo "$2 Huh?"
    ;;
esac

/bin/ls --time-style="+%Y-%m-%d %T" -lLFAGv ${BASE_FILENAME}.*

