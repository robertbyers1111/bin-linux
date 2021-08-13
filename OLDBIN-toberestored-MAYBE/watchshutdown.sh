#!/bin/bash

LOGF=~/watchshutdown.log
cp /dev/null $LOGF

while [ 1 ];
do
  echo >> $LOGF
  echo >> $LOGF
  echo >> $LOGF
  echo >> $LOGF
  echo >> $LOGF
  echo >> $LOGF
  date +=================================\ %Y-%m%d\ %H:%M:%S >> $LOGF
  top -b -n1 >> $LOGF
  date +=================================\ %Y-%m%d\ %H:%M:%S >> $LOGF
  sleep 1.5
done

