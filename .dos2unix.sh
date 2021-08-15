#!/bin/bash

# This script invokes dos2unix on a file repeatedly until the filesize no longer changes between
# iterations of dos2unix. It also uses '/bin/col -bx' to remove most control characters and
# escape sequences.

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
do_ls ()
{
    /bin/ls --time-style="+%Y-%m-%d %H:%M:%S" --group-directories-first -lLFANGv "$1"
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
do_getsize ()
{
    stat --format=%s "$1"
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
do_dos2unix ()
{
    dos2unix --quiet --force --keepdate "$1"
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
do_remove_crap ()
{
    NOW=`now -nc`
    TMPN=`mktemp -u -t dos2unix-$NOW-XXXX`
    ORIGSZ=`do_getsize "$1"`
    ORIGTIME_FMTA=`stat --format=%Y "$1"`
    ORIGTIME_FMTB=`date --date=@$ORIGTIME_FMTA +%y%m%d%H%M.%S` 
    cat "$1" | col -bx > "$TMPN"
    NEWSZ=`do_getsize "$TMPN"`
    [ $NEWSZ -gt 0 -a $NEWSZ -le $ORIGSZ ] && {
        cp -f "$TMPN" "$1" 
        touch -t $ORIGTIME_FMTB "$1"
        echo `do_getsize "$1"` "$1"
    }
    [ -f $TMPN ] && rm $TMPN
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
do_each_file_from_command_line()
{
    FILEN="$1"
    
    [ ! -f "$FILEN" ] && {
        [ -d "$FILEN" ] && {
            echo
            echo "ERROR: $FILEN is a directory (i.e., is not a file)"
            exit
        } || {
            echo
            echo "ERROR: $FILEN is not a regular file"
            exit
        }
    }
    
    do_ls "$FILEN"
    
    PREVSZ=-1
    CURRSZ=`do_getsize "$FILEN"`
    echo $CURRSZ $FILEN
    while [ $CURRSZ -ne $PREVSZ ]
    do
        do_dos2unix "$FILEN"
        PREVSZ=$CURRSZ
        CURRSZ=`do_getsize "$FILEN"`
        [ $CURRSZ -ne $PREVSZ ] && echo $CURRSZ $FILEN
    done
    
    do_remove_crap "$FILEN"
    do_ls "$FILEN"
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# * * *  M A I N  * * *

[ $# -lt 1 ] && { 
    echo
    echo USAGE: `basename $0` file...
    exit
}

FIRST=""
while [ $# -gt 0 ]
do
    $FIRST
    do_each_file_from_command_line "$1"
    FIRST=echo
    shift
done

do_remove_crap "$FILEN"
do_ls "$FILEN"
