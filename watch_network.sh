#!/bin/bash

COLS=`tput cols`
COLS=$((COLS-1))

doit()
{
    echo;echo;echo
    echo ================================================================================================
    date +%Y-%m%d-%H%M%S

    echo
    ifconfig enxa0cec8150043
    ifconfig cscotun0
    /home/rbyers/bin/monsyslog.sh | cut -c-$COLS

    echo
    date +"[%b %e %T (sleeping)]"
}

while [ 1 ]; do
    doit
    sleep 15
done
