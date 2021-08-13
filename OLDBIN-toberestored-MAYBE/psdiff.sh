#!/bin/bash

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# This script is useful for finding new or unwanted processes running on
# the system. It is designed to be run periodically via cron.
#
# This script performs a custom ps command, saving results to a known
# location (e.g., ~/var/log/psdiff-YYYY-MMDD-HHMMSS-NNN.log).
#
# Furthermore, if previous results are detected in the same directory, a
# diff is computed between the current and previous ps results.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

NOW=`date +%Y-%m%d-%H%M%S-%N | cut -c-20`

#-- Make sure home directory is defined and exists..
[ x${HOME} = x ] && HOME=$LOGNAME
[ x${HOME} = x ] && { echo Unable to determine user home directory; exit; }
[ ! -d $HOME ] && { echo $HOME not exist or is not a directory; exit; }

#-- Set up some basic variables..
BASENAME=psdiff
LOGDIR=$HOME/var/log/$BASENAME
LOGFILE=$LOGDIR/${BASENAME}-$NOW.log
DIFFFILE=`echo $LOGFILE | sed 's/.log$/.diff/'`
PSFMT="--format user,pid,spid,ppid,pgid,longtname,lstart,rss,size,sz,vsz,dsiz,euid,fsuid,fuid,ruid,suid,svuid,uid,uid_hack,fuser,ruser,suser,svuser,uname,user,cmd"

#echo BASENAME:$BASENAME
#echo LOGDIR:$LOGDIR
#echo LOGFILE:$LOGFILE
#echo DIFFFILE:$DIFFFILE
#echo PSFMT:$PSFMT

#-- Make sure log directory exists..
[ ! -d $LOGDIR ] && mkdir $LOGDIR
[ ! -d $LOGDIR ] && { echo $LOGDIR not exist or is not a directory; exit; }

#-- Find out if any previous psdiff results exist. Set HAVEPREV to 1 if
#-- previous result do in fact exist..

/bin/ls -1tr $LOGDIR/${BASENAME}-20*.log 1> /dev/null 2>&1
[ $? -eq 2 ] && HAVEPREV=0 || HAVEPREV=1
if [ $HAVEPREV -eq 1 ]; then
  PREVLOGFILE=`/bin/ls -1tr $LOGDIR/${BASENAME}-20*.log |tail -1`
fi

#-- Run the ps command, saving results to our logfile..

ps -e $PSFMT | sort -Vu > $LOGFILE

if [ $HAVEPREV -eq 1 ]; then
  diff $PREVLOGFILE $LOGFILE > $DIFFFILE
fi

