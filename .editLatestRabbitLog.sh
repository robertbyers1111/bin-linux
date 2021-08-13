#!/bin/bash

# Locates and opens the latest rabbit dev log file in gvim
#
# There are three log files from which to choose..
#
#    1. top level
#    2. mid level
#    3. deep dive (default)
#
# The levels refer to where in a single test run's log directory tree to find the log file for editing
#
# Example:
#                                                                                        ====================
#                                                                                           number of lines
#    ====== FOLDER ================    = LEVEL =    ======== LOGFILE ========            in logfile (example)
#                                                                                        --------------------
#    ~/rabbit/logs                        (1)       02.25_12-45-02_lewis.log                    12
#        +---- 02.25_12-45-02_lewis       (2)       02.25_12-45-02_lewis.log                   197
#            +---- dev                    (3)       dev_02.25_12-45-02_test_16906.log         4179
#    ==============================    =========    =================================    ====================
#
#    Use the command line to select a level other than the default.
#
#        USAGE: .editLatestRabbitLog.sh [level]

doit ()
{
    THISLOGFILE=$1
    echo LOGFILE: $THISLOGFILE
    [ -f $THISLOGFILE ] && gvim $THISLOGFILE || echo Logfile not found
}

. ~/bin/gotolatestlogdir.sh

LEVEL=$1
[ $# -eq 0 ] && LEVEL=3

case $LEVEL in

    1) echo Level 1
       LOGFILE=`pwd`/*.log
       doit $LOGFILE
       ;;

    2) echo Level 2
       LOGFILE=`pwd`/*/*.log
       doit $LOGFILE
       ;;

    3) echo Level 3
       LOGFILE=`pwd`/*/dev/dev_*.log
       doit $LOGFILE
       ;;

    all) echo All levels
       LOGFILE1=`pwd`/*.log
       LOGFILE2=`pwd`/*/*.log
       LOGFILE3=`pwd`/*/dev/dev_*.log 
       LOGFILES="$LOGFILE1 $LOGFILE2 $LOGFILE3"
       for LOGFILE in $LOGFILES
       do
           doit $LOGFILE
       done
       ;;

    *) echo ERROR: Invalid Level: $LEVEL
       exit
       ;;
esac

