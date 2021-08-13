#!/bin/bash

#   +---------+
#---| dofreqs |---
#   +---------+

dofreqs () {

  TMPF2=`mktemp -u --tmpdir=/tmp -t $(basename $0)_${USER}_$(echo 10i16o$(date +%s%N)p|dc)2XXXX.dat`

  #-- First step is to generate another temp file with only the unique values

    cat $1 | sort -Vu > $TMPF2

  #-- Now read in each unique value and find its frequency

    echo " Length   Frequency"
    {
    while read line; do
      printf " %4d     %4d\n" $line `grep -Ec "^[      ]*$line[        ]*$" $1`
    done < $TMPF2
    echo
    } | tail -25

  [ -f $TMPF2 ] && rm $TMPF2
}

#   +---------+
#---| dolines |---
#   +---------+

dolines () {
  cat $1 \
   | while read line
   do
     echo -n $line | wc -c
   done
}

#   +--------+
#---| dofile |---
#   +--------+

dofile ()
{
  [ $MULTIFILES -gt 0 ] && { echo; echo -n === $1; }

  if [ -f $1 ]
  then
    [ $MULTIFILES -gt 0 ] && echo
    TMPF1=`mktemp -u --tmpdir=/tmp -t $(basename $0)_${USER}_$(echo 10i16o$(date +%s%N)p|dc)0XXXX.dat`
    dolines $1 | sort -V > $TMPF1
    dofreqs $TMPF1
    [ -f $TMPF1 ] && rm $TMPF1
  else
    [ $MULTIFILES -gt 0 ] && echo " does not exist" || echo $1 does not exist
  fi
}

#   +--------+
#---| doargs |---
#   +--------+

doargs () {

  [ $# -lt 1 ] && { echo "USAGE: `basename $0` file.."; exit; }

  if [ $# -eq 1 ]; then
    MULTIFILES=0
    dofile $1
  else
    MULTIFILES=1
    while [ $# -ge 1 ]; do
      dofile $1
      shift
    done
  fi
}

#   +---------+
#---| M A I N |---
#   +---------+

  doargs $@

