#!/bin/bash

        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        # This script is for starting from user's $HOME
        #
        # Another script should be written for '/' as the starting point
        #
        # ..or make this script smart enough to do both?
        #
        # Either way, some of the exclusions for a '/' traversal would be..
        #
        #    -path /cdrom -prune -o \
        #    -path /dev -prune -o \
        #    -path /lost+found -prune -o \
        #    -path /media -prune -o \
        #    -path /mount -prune -o \
        #    -path /proc -prune -o \
        #    -path /timeshift -prune -o \
        #    -path /var/run -prune -o \
        #
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# This script runs 'find' for a user's home directory, with certain crucial
# exceptions for performance reasons (e.g., exclude ~/.snapshot, ~/.cache, etc.
#
# A case statement is used to customize the exclusions based on current hostname.

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
# adhere to a bash case statement's match pattern syntax. However, it should not
# include the trailing right parenthesis. Further, I found it won't work without
# enclosing the pattern in parenthesis *and* preceeding the entire string with a '+'.
#
# Example..
#
#         TO_EXCLUDE="+(this|that)"
#
# ..will result in the following case statement...
#
#         case $XXX in
#             +(this|that)) echo Found this or that ;;
#         esac
#
# ..yes, there are *two* right parentheses and only one left parenthesis. But
# the variable TO_EXCLUDE will have only one of each.
#
# (also, extglob is required for this to work)

    shopt -s extglob

    case $HOSTNAME in
        RB-EL*) TO_EXCLUDE="+(.|..|./.cache|./.snapshot|./nfs*|./.dbus|./.gconf|./.kde|./.vim|./.eclipse)" 
        ;;
        *) TO_EXCLUDE="+(.|..|./.cache|./.snapshot|./nfs*|./.dbus|./.gconf|./.kde|./.vim)" 
        ;;
    esac

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

