#!/bin/bash

NOW=`date +%Y-%m%d-%H%M%S`
CMD=$HOME/bin/.topcheck
OUTDIR=$HOME/var/topcheck
OUT=$OUTDIR/topcheck-${NOW}.log
AGEOUTDAYS=45

#-- Sanity checks

    if [ "$HOME" == "" ]; then
      echo HOME not set
      exit 100
    fi

    if [ ! -d $HOME ]; then
      echo $HOME doesnot exist
      exit 101
    fi

#-- Make sure the output directory exists

    [ ! -d $OUTDIR ] && mkdir -p $OUTDIR

    if [ ! -d $OUTDIR ]; then
      echo $OUTDIR does not exist
      exit 102
    fi

#-- Get rid of old logs

    find $OUTDIR -type f -mtime +$AGEOUTDAYS -exec rm {} \;

#-- Display a header

    ( echo
      echo ==== `basename $0` `date +%Y-%m%d\ %H:%M:%S` ===============================================
      echo
      echo '/^= .*'
      echo
      echo
      echo
      echo
    ) > $OUT


#-- Run the command

    $CMD >> $OUT

