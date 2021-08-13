#!/bin/sh
MBOX=/var/spool/mail/$LOGNAME
cat $MBOX
cp -f /dev/null $MBOX
