#!/bin/bash

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Creates a backup of a file. Name of the backup file uses the file's last modifed timestamp.
#
# Does not support filenames containing spaces
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

LSCUSTOM='/bin/ls --time-style="+%Y-%m-%d %H:%M:%S" -lLG'

Usage ()
{
    printf "Usage: `basename $0` file...\n"
    exit
}

[ $# -lt 1 ] && Usage

for VAR in $*
do
    #cho
    #cho =====
    #cho "       FILE: $VAR"

    [ ! -f "${VAR}" ] && echo $VAR not exist or is not a regular file || (

        BASENAME=`basename $VAR`
        #cho "   BASENAME: $BASENAME"

        echo $BASENAME | grep -q "\." 
        if [ $? -eq 0 ]
        then
            BASENAME_NE=`echo $BASENAME | sed 's/\(.*\)[.]\([^.][^.]*\)/\1/'`
            EXT=.`echo $BASENAME | sed 's/\(.*\)[.]\([^.][^.]*\)/\2/'`
        else
            BASENAME_NE=$BASENAME
            EXT=""
        fi
    
        #cho "BASENAME_NE: $BASENAME_NE"
        #cho "        EXT: $EXT"

        TIMESTAMP=`/bin/ls --time-style=+%Y-%m%d-%H%M%S -lLG $VAR | cut -d\  -f5`
        #cho "  TIMESTAMP:" $TIMESTAMP

        BKUPNAME=.BKUP-${BASENAME_NE}_Rev${TIMESTAMP}${EXT}
        if [ -f $BKUPNAME ]
        then
            echo $BKUPNAME already exists
            md5sum $VAR
            md5sum $BKUPNAME
        else
            CMD="cp -p $VAR $BKUPNAME"
            echo $CMD
            $CMD
        fi
    )
done

