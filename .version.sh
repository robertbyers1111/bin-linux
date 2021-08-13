#!/bin/bash

# LSB is 'Linux standard base'
# CPE is 'Common Platform Enumeration'

COLS=`/usr/bin/tput cols`

doit ()
{
    echo
    echo \> $*
    $* | cut -c-$COLS
}

FILE=/etc/os-release         ; [ -f $FILE ] && doit cat $FILE
FILE=/etc/lsb-release        ; [ -f $FILE ] && doit cat $FILE
FILE=/etc/system-release     ; [ -f $FILE ] && doit cat $FILE
FILE=/etc/system-release-cpe ; [ -f $FILE ] && doit cat $FILE
FILE=/etc/redhat-release     ; [ -f $FILE ] && doit cat $FILE
FILE=/etc/centos-release     ; [ -f $FILE ] && doit cat $FILE
FILE=/etc/linuxmint/info     ; [ -f $FILE ] && doit cat $FILE

doit uname -mrs
doit cat /proc/version
doit python -mplatform

