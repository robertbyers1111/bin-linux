#!/bin/bash
# Uses ps and pgrep to find one or more processes
[ $# -lt 1 ] && { echo USAGE: `basename $0` pattern.. ; exit; }
while [ $# -gt 0 ]; do
    $ECHOCMD
    PSLIST=`pgrep -d, $1`
    [ $? -eq 0 ] && ps -fj -p$PSLIST || echo No processes found matching $1
    # only showing blank line if more than one arg
    ECHOCMD=echo
    shift
done
