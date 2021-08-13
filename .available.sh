#!/bin/bash

DAYS2UPDATE=7
THEFILE=/tmp/notinstalled.log

find $THEFILE -mtime +$DAYS2UPDATE > /dev/null 2>&1
[ $? -gt 0 ] && aptitude search "?not(?installed)" > $THEFILE
[ $# -gt 0 ] && { grep -iE $* $THEFILE ; exit ; } || cat $THEFILE
