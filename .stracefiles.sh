#!/bin/bash

# This script extracts all the names of files referenced in an strace output file

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# doit() identifies the file types of all discored files
doit()
{
    while read line
    do
        TYPE=`file -b $line `
        echo $TYPE: $line \
         | sed 's/^\(ELF .*object\)\(.*stripped\)\(.*\)/\1\3/'
    done < "$1"
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# M A I N

[ $# -ne 1 ] && { echo USAGE: `basename $0` file; exit; }
[ ! -f "$1" ] && { echo File not exist: $1; exit; }

TMPDIR=.
TMPFILEBASE=`mktemp -u --tmpdir=$TMPDIR -t $(basename $0)_${USER}_$(echo 10i16o$(date +%s%N)p|dc)XXXX`
TMPFILE_A=${TMPFILEBASE}_all.tmp
TMPFILE_E=${TMPFILEBASE}_errs.tmp
TMPFILE_N0=${TMPFILEBASE}_noErrsA.tmp
TMPFILE_N1=${TMPFILEBASE}_noErrs1.tmp
TMPFILE_N2=${TMPFILEBASE}_noErrsF.tmp
TMPFILE_N3=${TMPFILEBASE}_noErrsD.tmp
TMPFILE_O=${TMPFILEBASE}_organized.tmp

#First grep of the trace file..
grep \" "$1" | grep -Ev '/__pycache__/|read\(|write\(|read resumed|getrandom' > $TMPFILE_A

echo " [`date +%H:%M:%S.%N | cut -c-12`]                 All files: $TMPFILE_A (`wc -l $TMPFILE_A | cut -d\  -f1`)"

#Find errors
    grep -E ')\s*=\s*\S+\s*E' $TMPFILE_A \
     | cut -d\" -f2 \
     | sort -Vu \
     > $TMPFILE_E

    echo " [`date +%H:%M:%S.%N | cut -c-12`]                    Errors: $TMPFILE_E (`wc -l $TMPFILE_E | cut -d\  -f1`)"

#Find non-errors
    grep -Ev ')\s*=\s*\S+\s*E' $TMPFILE_A \
     | cut -d\" -f2 \
     | sort -Vu \
     > $TMPFILE_N0

    echo " [`date +%H:%M:%S.%N | cut -c-12`]                Non-errors: $TMPFILE_N0 (`wc -l $TMPFILE_N0 | cut -d\  -f1`)"

#Post-processing to organize the results by file type

    doit $TMPFILE_N0 | sort -V > $TMPFILE_N1
    grep -Ev "^cannot open|^directory" $TMPFILE_N1 > $TMPFILE_N2
    grep -E  "^cannot open|^directory" $TMPFILE_N1 > $TMPFILE_N3
    {
        echo
        echo [Files] ================================================================
        cat $TMPFILE_N2
        echo
        echo [Directories and cannot-opens] =========================================
        cat $TMPFILE_N3
    } > $TMPFILE_O

    echo " [`date +%H:%M:%S.%N | cut -c-12`]     Files from non-errors: $TMPFILE_N2 (`wc -l $TMPFILE_N2 | cut -d\  -f1`)"
    echo " [`date +%H:%M:%S.%N | cut -c-12`] Non-Files from non-errors: $TMPFILE_N3 (`wc -l $TMPFILE_N3 | cut -d\  -f1`)"
    echo " [`date +%H:%M:%S.%N | cut -c-12`]      Organized non-errors: $TMPFILE_O (`wc -l $TMPFILE_O | cut -d\  -f1`)"
    gvim $TMPFILE_O
