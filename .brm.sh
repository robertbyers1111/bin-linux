#!/bin/bash

NOW=`date +%y%m%d_%H%M%S`
NOWSECSHEX=`date +10i16o%sp%Np | dc | sed ':a;N;$!ba;s/\n/./g'`
TRASH=$HOME/.trash
SPACE=""
OPTS=""

[ ! -d $TRASH ] && { echo $TRASH does not exist; exit; }

#-- Check cmd line for 'rm -rf'; if so, move the entire directory into trash

[ "_$1" = "_-rf" ] && {
    shift
    echo Detected 'rm -rf', moving everything to ~/.trash/$NOW
    mv $* ~/.trash/$NOW
    exit
}

#-- Process each command line arg

while [ $# -gt 0 ]; do

  CASEVAL=`echo $1 | cut -c1-1`
  case $CASEVAL in

    -) OPTS="$OPTS$SPACE$1"
       SPACE=" "
       ;;

    *) FILE="$1"
       BASENAME=`basename "$FILE"`
       #-- Don't move links
       if [ -h "$FILE" ]; then
          rm $OPTS "$FILE"
       else
         #-- Do an rm (instead of mv) if any options are specified
         if [ x$OPTS != x ]; then
                rm $OPTS "$FILE"
         #-- Move it to ~/.trash
         else
            MODTIME_EPOCH=`stat -c %Y "$FILE"`
            MODTIME=`date -d @$MODTIME_EPOCH +%Y-%m%d-%H%M%S`
            mv "$FILE" "$TRASH/$BASENAME.MODIFIED-$MODTIME.TRASHED-$NOWSECSHEX"
         fi
       fi
  esac
  shift
done

