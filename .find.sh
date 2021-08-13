#!/bin/bash +xv

# No args supported yet!
#
# NOTE: Args to this script were not very useful the way I first implemented them
# (all args are passed as find expressions *after* the EXCLUDEDIRS expression. But
# there's no way to easily allow args for the 'find' command that should appear prior
# to the EXCLUDEDIRS clause, as well as easily allow args after that clause.
#
# (by 'easily', I mean easy to remember for a command I use mabe 1/week tops)
#
# TODO:
# Which would be more useful? Only support one or the other?
#
# Or, have a non-trivial command line option set, and print out usage/help with the
# allowable syntax? Print Usage either when zero args supplied or --help is specified

STARTING_POINT=/

EXCLUDEDIRS="\
-path /cdrom -prune -o \
-path /dev -prune -o \
-path /lost+found -prune -o \
-path /media -prune -o \
-path /mount -prune -o \
-path /proc -prune -o \
-path /timeshift -prune -o \
-path /var/run -prune -o \
-print"

echo "find $STARTING_POINT $EXCLUDEDIRS | grep -Ev \"Permission denied\" 2>&1"
find $STARTING_POINT $EXCLUDEDIRS 2>&1 | grep -Ev "Permission denied"

