#!/bin/bash

[ $# -ne 1 ] && { echo Usage: `basename $0`; exit; }
[ ! -r "$1" ] && { echo $1 is either not readable, not a file, or does not exist; exit; }

echo
/bin/ls --time-style="+%Y-%m-%d %H:%M:%S" -lLFAGv $1
dos2unix --quiet --force --keepdate "$1"
dos2unix --quiet --force --keepdate "$1"
/bin/ls --time-style="+%Y-%m-%d %H:%M:%S" -lLFAGv $1
