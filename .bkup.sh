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


            echo
            /bin/ls --time-style="+%Y-%m-%d %H:%M:%S" --group-directories-first -ltLFANGv "$BKUP_DIR/${BASEFN}.20"* | tail -8

            echo
            CHECKFILES=`/bin/ls -1tr "$BKUP_DIR/${BASEFN}.20"* | tail -8`
            for CHECKFILE in $CHECKFILES $1
            do
                sha256sum "$CHECKFILE" | sed 's/.home.rbyers//'
            done
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

