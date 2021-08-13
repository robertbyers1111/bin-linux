#!/bin/bash

BKUP_DIR=~/.bkups

[ $# -lt 1 ] && { echo USAGE `basename $0` file..; exit; }
[ ! -d $BKUP_DIR ] && { echo ERROR $BKUP_DIR NOT EXIST OR NOT A DIRECTORY; exit; }

doit()
{
    [ -f "$1" ] && {
        [ -r "$1" ] && {
            BASEFN=`basename "$1"`
            MODTIME_EPOCH=`stat -c %Y "$1"`
            MODTIME=`date -d @$MODTIME_EPOCH +%Y-%m%d-%H%M%S`
            NOW=`date +%s%N`
            SAVEME="$BKUP_DIR/$BASEFN.${MODTIME}_${NOW}"
            cp -ip "$1" "$SAVEME"
            sha256sum "$1"
            sha256sum "$SAVEME"
        } || {
            echo $1 is not readable
            /bin/ls -l "$1"
        }
    } || {
        echo $1 is not a regular file
        file "$1"
    }
}

while [ $# -gt 0 ]
do
    doit "$1"
    shift
done

