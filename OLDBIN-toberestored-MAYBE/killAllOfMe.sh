#!/bin/sh
PIDLIST=`ps -ubbyers -o pid=`
for PIDVAL in $PIDLIST
do
  kill -9 $PIDVAL
done
