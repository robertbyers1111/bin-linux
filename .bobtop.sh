#!/bin/bash

doit()
{
    date +"=== %Y-%m%d-%H%M%S"
    uptime | sed 's/[0-9][0-9]*:[0-9][0-9]*:[0-9][0-9]*  *//'
}

while [ 1 ]; do
    doit | paste - -
    sensors -f
    sleep 60
done

