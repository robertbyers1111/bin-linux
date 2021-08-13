#!/bin/bash

. $HOME/lib/bbyerslib.sh

if [ "x${ANVILRC}" != "x" ]; then
  ANVILRC_FILE=$ANVILRC
else
  ANVILRC_FILE=~/.anvilrc
fi

case $# in

  1|2) I=1
     NARGS=$#
     while [ $I -le $NARGS ]; do
       if echo $1 | egrep -q anvilrc; then
         ANVILRC_FILE=$1
       else
         BASESUBNET=$1
       fi
       shift
       I=`expr $I + 1`
     done
  ;;

  *) echo
     echo "USAGE: `basename $0` subnet [anvilrc_file]"
     echo
     echo "    EXAMPLE: `basename $0` 172.16"
     echo
     exit
  ;;

esac

if [ ! -f $ANVILRC_FILE ]; then
  echo $ANVILRC_FILE NOT EXIST
  exit
fi


#zzz# #-- Use a different .anvilrc if one exists matching rigname from AUTO_RIGSETUP
#zzz#
#zzz# if [ "$RIGNAME" = "" ]; then
#zzz#   if [ ! "$AUTO_RIGSETUP" = "" ]; then
#zzz#     RIGNAME=`echo $AUTO_RIGSETUP | sed 's/^.*automation.setups.\(.*\).setup/\1/'`
#zzz#   fi
#zzz# fi
#zzz#
#zzz# TESTVAL=$HOME/.anvilrc_$RIGNAME
#zzz#
#zzz# if [ -f $TESTVAL ]; then
#zzz#   ANVILRC=$TESTVAL
#zzz# fi


RANGE=`egrep "range.*$BASESUBNET" $ANVILRC_FILE |\
 sed "s/^${ZSPACES}range${SPACES}\($NUMS\.$NUMS\.$NUMS\.$NUMS\)${SPACES}\($NUMS\.$NUMS\.$NUMS\.$NUMS\).*$/\1 \2/"`

$BBIN/UTY_sharksubs.tcl $RANGE

