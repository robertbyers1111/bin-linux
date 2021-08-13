#!/bin/bash
DARTIP=10.0.0.12
while [ 1 ]
do
    echo
    echo ================================================================================
    date +%Y-%m%d-%H:%M:%S
    ping -c 3 -i 1 -W 3 $DARTIP
    arp -n $DARTIP
    sleep 5
done
