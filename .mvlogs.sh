#!/bin/bash
#
# [OBSOLETE]
#
# Move robomaker logs from ~/downloads into a new directory under ~/iRobot/logs

# BUG: each call to moveit moves only the first file that matches the pattern

USAGE() { echo "Usage: `basename $0` [jenkins_number]" ; exit ; }

[ $# -lt 0 -o $# -gt 1 ] && USAGE
[ "_$1" = "_" ] && JENKINS_SUFFIX="" || JENKINS_SUFFIX="_jenkins-"$1

#RC=~/iRobot/logs
SRC=~/downloads
DEST_PREFIX=~/iRobot/logs

moveit()
{
    for filename in $1
    do
        [ -f $filename ] && {
            echo "  moving `basename $filename`"
            mv $filename .
        }
    done 
}

movem()
{
    moveit $devlog
    moveit $SRC/finished-debug-console.txt
    moveit $SRC/debug-console*.txt
    moveit $SRC/mqtt-*events*.txt
    moveit $SRC/mob-*events*.txt
    moveit $SRC/*_test_*.log
    moveit $SRC/*.csv
    moveit $SRC/evaluation_report.json
    moveit $SRC/mob-debug-console.txt
    moveit $SRC/robomakersim*
    moveit $SRC/sim-mqtt*
    moveit $SRC/event*.txt
    moveit $SRC/event*.json
    moveit $SRC/roboscope*
}

for devlog in ${SRC}/dev_*_test_*.log
do
    [ ! -f $devlog ] && { echo no more dev logs in $SRC ; exit ; }
    echo
    echo Processing `basename $devlog`
    DIRNAM=${DEST_PREFIX}/logs-`echo $devlog | sed 's/.*dev_\(..\..._..-..-..\)_test_.*/\1/'`${JENKINS_SUFFIX}
    [ -d $DIRNAM ] && { echo `basename $DIRNAM` already exists in $DEST_PREFIX ; exit ; }
    echo "  Creating $DIRNAM"
    mkdir $DIRNAM
    cd $DIRNAM
    movem
    #echo `/bin/ls -1 $DIRNAM | wc -l` files in `basename $DIRNAM`
    echo
    echo "[`basename $DIRNAM`/]"
    /bin/ls --time-style="+%Y-%m-%d %H:%M:%S" --group-directories-first -lLFAGv $DIRNAM | grep -v ^total | sed 's/^/  /'
done

