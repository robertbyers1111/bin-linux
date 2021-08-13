#!/bin/bash

# This script displays as sorted list of all functions found in a one or more python files.
#
# USAGE: .funcs.sh file...
#

doit()
{
    [ -f $1 ] && { grep -E "^\s+def\s" $1 | sort -Vu ; } || { echo ERROR: $1 not exist ; }
}

while [ $# -gt 0 ]; do
    doit $1
    shift
done

