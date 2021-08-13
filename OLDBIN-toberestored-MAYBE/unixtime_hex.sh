#!/bin/bash

#-- This script displays unix time (secs since Jan 1, 1970 UTC) in hex.
#--
#-- If no cmdline args are given, the current unix time is used. Otherwise
#-- takes unix time in decimal from 1st cmd line param.

[ $# -eq 1 ] && UNXTIME=$1 || UNXTIME=`date +%s`

echo 10i 16o ${UNXTIME} p | dc
