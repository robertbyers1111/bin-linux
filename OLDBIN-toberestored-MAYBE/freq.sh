#!/bin/bash

#-------------------------------------------------------------------------------
#
# FILE: freq.sh
#
# This is a stab at producing a FREQ script for text files. Work in progress
#
# Currently, reads from stdin. The user is expected to extract the relevant
# columns (e.g., using sed or cut) and pass only those colums into this script.
#
# EXAMPLE:
#
#            grep XYZ mydata.txt | cut -d: -f5 | freq.sh
#
#-------------------------------------------------------------------------------

TMPF1=`mktemp -u --tmpdir=/tmp -t $(basename $0)_${USER}_$(echo 10i16o$(date +%s%N)p|dc)XXXX.dat`
TMPF2=`mktemp -u --tmpdir=/tmp -t $(basename $0)_${USER}_$(echo 10i16o$(date +%s%N)p|dc)XXXX.dat`

#-- Zeroth step is to write stdin to a temp file

    grep . > $TMPF1

#-- First step is to generate another temp file with only the unique values

    cat $TMPF1 | sort -u > $TMPF2

    echo
    echo There are `wc -l $TMPF2 | sed 's/ .*//'` unique values

#-- Now read in each unique value and find its frequency

    echo
    while read line; do
      echo Value: $line "	" Frequency: `grep -Ec "^[ 	]*$line[ 	]*$" $TMPF1`
    done < $TMPF2
    echo

#-- That is all for now

    [ -f $TMPF1 ] && rm $TMPF1
    [ -f $TMPF2 ] && rm $TMPF2

