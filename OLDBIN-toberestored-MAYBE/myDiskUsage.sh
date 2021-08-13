#!/bin/bash

. /home/bbyers/lib/bbyerslib.sh

INFI=$BVAR/bbyers/allMyFiles.txt

if [ -f $INFI ]; then

  echo 0 > $TMPF

  cat $INFI \
   | sed 's/,//g' \
   | sed 's/^  *//' \
   | sed 's/ .*//g' \
   | sort -hr \
   | egrep -v "^0$" \
   | sed 's/$/+/' \
   >> $TMPF

   echo p >> $TMPF

   echo `date +[%y/%m/%d\ %H:%M:%S]` My total disk usage: `dc < $TMPF | $BBIN/commify` bytes

else
  echo WTF $INFI no exist
fi

[ -f $TMPF ] && rm $TMPF 
