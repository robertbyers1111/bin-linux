#!/bin/bash
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Display the various dates (created, modified, acces, status) of one or more files
#
# Usage: .fdates.sh FILE...
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

[ $# -lt 1 ] && { echo USAGE `basename $0` file..; exit; }

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
doit()
{
    CREATED=`stat -c %w "$1"`
    MODIFIED=`stat -c %y "$1"`
    ACCESS=`stat -c %x "$1"`
    STATUS=`stat -c %z "$1"`
    [ ! _$CREATED = "_-" ] && echo "      CREATED: $CREATED (stat -c %w)"
    echo "   MODIFIED: $MODIFIED (stat -c %y)"
    echo "     ACCESS: $ACCESS (stat -c %x)"
    echo "     STATUS: $STATUS (stat -c %z)"
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  ***  M A I N  ***

while [ $# -gt 0 ]
do
    echo
    echo $1
    doit $1 | sort -t: -k2
    shift
done
