#!/bin/bash

# This script creates a gzipped tarfile of the given rabbit log directory, but with the large roboscope files excluded
# User should be in RABBIT_HOME or one level above a Rabbit logs directory

[ $# -ne 1 ] && { echo USAGE: `basename` logs/RABBIT_LOGS_DIR; exit; }

[ ! -d logs ] && {
    echo logs directory not found in current directory `pwd`
} || {
    echo OK
}

[ ! -d logs ] && { echo logs directory not found in current directory `pwd`; exit; }

exit

# Make sure command line arg points to a valid rabbit results directory

FOUND_LOG=0
FOUND_DIR=0
LSOUT=`/bin/ls -1 $1`
for X in $LSOUT
do
    echo $X | grep -q "\.log$"
    [ $? -eq 0 -a -f $X ] && FOUND_LOG=1

    echo $X | grep -q "_test_"
    [ $? -eq 0 -a -d $X ] && FOUND_DIR=1
done

echo FOUND_LOG:$FOUND_LOG
echo FOUND_DIR:$FOUND_DIR

[ $FOUND_DIR -ne 1 -o $FOUND_LOG -ne 1 ] && {
    echo Failed to confirm $1 is a rabbit results directory
    exit
}

