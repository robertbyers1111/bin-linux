#!/bin/bash

. /home/bbyers/lib/bbyerslib.sh

uptime \
 | sed 's/day,/day/' \
 | sed 's/days,/days/' \
 > $TMPF

D1=`cat $TMPF | cut -d, -f1`
D2=`cat $TMPF | cut -d, -f2`
D3=`cat $TMPF | cut -d, -f3`
D4=`cat $TMPF | cut -d, -f4`
D5=`cat $TMPF | cut -d, -f5`
D6=`cat $TMPF | cut -d, -f6`
D7=`cat $TMPF | cut -d, -f7`
D8=`cat $TMPF | cut -d, -f8`
D9=`cat $TMPF | cut -d, -f9`

D3a=`echo $D3 | cut -d: -f1`
D3b=`echo $D3 | cut -d: -f2`

printf "%-28s %-9s %-12s: %6.2f %6.2f %6.2f %s %s %s %s %s %s" \
 "$D1" "$D2" "$D3a" "$D3b" "$D4" "$D5" "$D6" "$D7" "$D8" "$D9" \
 | sed 's/  *$//'

echo

rm $TMPF
