#!/bin/bash
#----------------------------------------------------------------
#
# This script creates a time-stamped version of one or more files.
# Destination is a shadow directory tree underneath the user's home.
#
# USAGE: bkup.sh file ..
#
# The shadow tree is in $HOME/.bkups
#
#----------------------------------------------------------------

#-- Quickly backup one or more files

NOW=`date +%Y-%m%d-%H%M%S`
BASEDIR=$HOME/.bkups

#-- Check command line
[ $# -eq 0 ] && { echo USAGE: `basename $0` file .. ; exit ; }

#-- HOME variable must exist
[ X$HOME = X ] && { echo WTF HOME variable does not exist ; exit ; }

#-- Loop through each command line argument

while [ $# -gt 0 ]; do

  #-- $1 is the next file to be backed up

  #-- If it doesn't exist, skip to the next cmd line arg..

 #[ ! -f "$1" ] && { echo $1 does not exist ; shift ; continue ; }
  [ ! -f "$1" ] && { shift ; continue ; }

  dol1Dirname=`dirname "$1"`
  dol1Canonical=`readlink -fn "$dol1Dirname"`
  BKUPNAME=`basename "$1"`

  #-- Files to ignore

    if echo $1 | egrep -q ".swp$"
    then
      shift
      continue
    fi

  #-- Get file's mod time and make format appropriate for a directory name

  MODTIME=`stat -c%y $1 | sed 's/^\([12][09][0-9][0-9]-[01][0-9]\)-\([0-3][0-9]\) \([0-2][0-9]\):\([0-5][0-9]\):\([0-5][0-9]\)[0-9\.]* \(.*\)/\1\2-\3\4\5/'`

  #-- This assumes file is on /u4/USERNAME/USERNAME/ (but if not, nothing breaks)

  BKUPDEST=`echo "$BASEDIR/$dol1Canonical/$BKUPNAME/$MODTIME" | sed "s@/u4/$USER/$USER@@" | sed "s@//@/@g"`

  #-- Create the backup directory

  [ ! -d "$BKUPDEST" ] && mkdir -p "$BKUPDEST"
  [ ! -d "$BKUPDEST" ] && { echo WTF unabled to confirm $BKUPDEST exists ; exit ; }

  #-- Perform the backup

  FULLBKUPNAME="$BKUPDEST/$BKUPNAME"

  [ ! -f "$FULLBKUPNAME" ] && { echo "$FULLBKUPNAME" ; cp -up $1 "$FULLBKUPNAME" ; }

  [ ! -f "$FULLBKUPNAME" ] && { echo WTF unabled to confirm $1 was backed up as $FULLBKUPNAME ; }

  #-- Move on to next cmd line arg
  shift

done

     #---- OLDER VERSION ----------------------------------------
     #
     #  #-- Create the backup directory
     #
     #  [ ! -d $BKUPDIR ] && mkdir -p $BKUPDIR
     #  [ ! -d $BKUPDIR ] && { echo WTF unabled to confirm $BKUPDIR exists ; exit ; }
     #
     #  d1Canonical2=`readlink -fn $1`
     #  echo "d1Canonical2: $d1Canonical2"
     #
     #  BKUPDEST=$BKUPDIR/${dollarOneBasename}-$NOW
     #
     #  #-- Do the backup
     #
     #  cp -npv $1 $BKUPDEST
     #  if [ -f $BKUPDEST ]; then
     #    echo Created $BKUPDEST
     #  else
     #    echo WTF unabled to confirm $BKUPDEST was created
     #  fi
     #
     #-----------------------------------------------------------

