#!/bin/bash

[ $# -lt 1 ] && { echo USAGE: `basename $0` file..; exit; }

case `hostname` in
    IRBT-8758l) echo CLIENT `hostname`
        REMOTE_USER=rmbjr60
        REMOTE_HOST=10.0.0.6
        REMOTE_DEST=downloads
        ;;
    RmbInspiro2018) echo CLIENT `hostname`
        REMOTE_USER=irobert
        REMOTE_HOST=IRBT-8758l
        REMOTE_DEST=downloads
        ;;
    *) echo bad hostname! `hostname`
       exit
       ;;
esac

for F in $*
do
    CMD="scp $F $REMOTE_USER@$REMOTE_HOST:$REMOTE_DEST"
    echo $CMD
    $CMD
done

