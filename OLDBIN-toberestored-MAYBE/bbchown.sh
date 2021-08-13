#!/bin/sh

NEWGROUP=src

NEWUSER=$LOGNAME
if [ "$NEWUSER" = "" ]; then
  NEWUSER=$USER
  if [ "$NEWUSER" = "" ]; then
    echo Unabled to determine your username - this is not an error if you use the '-u' command line option
  fi
fi

if [ $# -lt 1 ] ; then
  echo
  echo USAGE:
  echo `basename $0` [-u username] file..
  echo
  exit
fi

while [ $# -gt 0 ]; do

  case $1 in

    -u) shift
        # Found '-u', next arg is a username (not a filename)
        NEWUSER=$1
        echo Setting ownership\(s\) to $NEWUSER
        ;;

    *)  if [ -f $1 -o -d $1 ]; then
          if [ "$NEWUSER" = "" ]; then
             echo WTF I have no username for changing ownership of $1
          else

             CMD="sudo chown $NEWUSER:$NEWGROUP $1"
             echo $CMD
             $CMD

             CMD="chmod g-w,g+r,o-w,o+r $1"
             echo $CMD
             $CMD

           fi
        else
          echo $1 does not exist
        fi
        ;;

  esac

  shift

done

