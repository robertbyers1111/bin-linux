#!/bin/sh

[[ $# -gt 1 ]] && { echo USAGE: `basename $0` [file]; exit; }

if [ $# -eq 1 ]; then
  [ ! -f $1 ] && { echo WTF: \'$1\' does not exist!; exit; }
fi

egrep -v "[a-zA-Z]  *0  *0  *0  *0  *0  *0 *$|\
[a-zA-Z]  *-  *-  *0  *0  *0 *$|\
[a-zA-Z]  *-  *-  *-  *0  *0  *0 *$|\
[a-zA-Z]  *0  *0  *0 *$|\
[a-zA-Z<>]  *0  *0  *0  *0  *0  *0 *$|\
NO DATA AVAILABLE\
" $1
