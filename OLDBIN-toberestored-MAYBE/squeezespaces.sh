#!/bin/sh

case $# in
  0) sed 's/^[ 	][ 	]*//' | sed 's/[ 	][ 	]*$//' | sed 's/[ 	][ 	]*/ /g'
     ;;
  1) if [ -f $1 ]; then
       cat $1 | sed 's/^[ 	][ 	]*//' | sed 's/[ 	][ 	]*$//' | sed 's/[ 	][ 	]*/ /g'
     else
       echo WTF $1 does not exist
       exit
     fi
     ;;
  *) echo USAGE: `basename $0` [file]
     ;;
esac

