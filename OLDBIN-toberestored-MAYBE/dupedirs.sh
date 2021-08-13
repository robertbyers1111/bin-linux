#!/bin/bash

[ $# -ne 1 ] && { echo Usage: `basename $0` topdir; exit; }
[ ! -d $1 ] && { echo $1 is not a directory; exit; }

ls -lR ${1}/ \
 | grep -E $(ls -lR ${1}/ \
 | grep ^d \
 | rev \
 | cut -d" " -f1 \
 | rev \
 | sort \
 | uniq -d \
 | head -c -1 \
 | tr '\n' '|') \
 | grep -v ^d \
 | sed 's/://'

