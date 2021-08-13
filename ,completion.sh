#!/bin/bash
UNIX_NOTES_DIR=~/public_html/unix
HELP_FILE=$UNIX_NOTES_DIR/tabcompletion.txt
[ ! -d $UNIX_NOTES_DIR ] && { echo ERROR: $UNIX_NOTES_DIR NOT EXIST; exit; }
[ ! -r $HELP_FILE ] && { echo ERROR: $HELP_FILE either does not exist, is not a regular file, or is not readable; exit; }
cat $HELP_FILE
