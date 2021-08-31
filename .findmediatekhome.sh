#!/bin/bash

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# This script runs 'find' for a user's home directory, with certain crucial
# exceptions for performance reasons (e.g., exclude ~/.snapshot, ~/.cache, etc.

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# variable: TO_EXCLUDE
#
# This variable defines all directories and files from user's home that should
# be excluded. NOTE that some additional objects will be excluded as well (e.g.,
# symbolic links, ".", "..", and anything that is not either a regular file or
# a regular directory.
#
# You can *only* specify directories residing in your home directory. This script
# is not set up allow deeper directories to be excluded. (that is a TODO item)
#
# This variable is used as a match pattern in a bash case statement, and must
# adhere to the case match pattern syntax. However, it should not include the
# trailing right parenthesis. Further, I found it won't work without enclosing
# the pattern in parenthesis *and* preceeding the entire string with a '+'.
#
# (also, extglob is required for this to work)

    shopt -s extglob
    TO_EXCLUDE="+(.|..|./.cache|./.snapshot|./nfs*|./.dbus|./.gconf|./.kde|./.vim|./.eclipse)"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# assemble_dirs()
#
# This function assembles a space-separated list of files and directories
# from the user's home directory, with certain exclusions as follows..
#
# + Only regular files and directories are included (which implies symbolic
#   links are ignored)
#
# + Directories and files appearing in the list of excluded objects are excluded

assemble_dirs() {
    for XXX in `(cd ~;find -maxdepth 1)`
    do
        case $XXX in
            ${TO_EXCLUDE})
            ;;
            *) [ -f $XXX -o -d $XXX -a ! -L $XXX ] && {
                DIRS="${DIRS}${SPACE}${XXX}"
                SPACE=" "
            }
            ;;
        esac
    done
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
usage() {
    echo USAGE: `basename $0` _find_params_
    exit
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ***  M A I N  ***

[ $# -lt 1 ] && usage
cd ~
assemble_dirs
set -o noglob
find $DIRS $*

