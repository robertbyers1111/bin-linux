#!/bin/bash

doit()
{
    echo
    echo === $1 ===
    ping -v -i1 -t1 -w2 -W2 -c2 $1
    arp -avn $1
}

while [ 1 ]; do
    echo;echo
    date +"===== %Y-%m%d-%H%M%S ====="
    doit 10.0.0.10
    doit 10.0.0.18
    sleep 4
done
