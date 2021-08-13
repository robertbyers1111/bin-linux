#!/bin/bash
THIS_HOST=10.0.0.18
REMOTE_HOST=10.0.0.6
REMOTE_USER=rmbjr60
NETIF=wlp59s0
GREP_STRINGS=~/etc/syslog_strings_01.grep
LOGFILE=/var/log/syslog

doit()
{
    echo
    date +===================================================

    date +"%n[REMOTE DATE] %Y-%m%d-%H:%M:%S"
    ssh $REMOTE_USER@$REMOTE_HOST date

    date +"%n[REMOTE lsof] %Y-%m%d-%H:%M:%S"
    ssh $REMOTE_USER@$REMOTE_HOST lsof -n -i @$THIS_HOST

    date +"%n[LOCAL lsof] %Y-%m%d-%H:%M:%S"
    sudo lsof -n -i @$REMOTE_HOST

    date +"%n[LOCAL ifconfig] %Y-%m%d-%H:%M:%S"
    ifconfig $NETIF

    date +"%n[LOCAL net messages] %Y-%m%d-%H:%M:%S"
    grep -f $GREP_STRINGS $LOGFILE | tail -100

    sleep 2
}

while [ 1 ]
do
    doit
done
