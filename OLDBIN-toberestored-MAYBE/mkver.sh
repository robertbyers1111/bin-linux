#!/bin/bash
. /home/bbyers/lib/bbyerslib.sh

BKUPDIR=$HOME/bkups

if [ $# -eq 0 ]; then
  echo USAGE: `basename $0` file..
  exit
fi

if [ ! -d $BKUPDIR ]; then
  mkdir $BKUPDIR
  if [ ! -d $BKUPDIR ]; then
    echo ERROR: unabled to create $BKUPDIR
    exit
  fi
fi

while [ $# -gt 0 ]; do
  if [ -h $1 ]; then
     echo "   $1 is a link - skiping"
  else
     if [ -f $1 ]; then
       BKUPFILE=$BKUPDIR/${1}_${NOW}
       cp $1 $BKUPFILE
       if [ -f $BKUPFILE ]; then
          if [ "$BEENHERE" = "" ]; then
            echo
            echo File\(s\) are copied to..
            BEENHERE=1
          fi
          echo "   $BKUPFILE" | sed 's#^\([ 	][ 	]*\)/home/[^/][^/]*/#\1~/#'
       else
          echo ERROR: unabled to copy $1 to $BKUPFILE
       fi
     else
       echo "   $1 not exist"
     fi
  fi
  shift
done
