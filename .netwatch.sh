#!/bin/bash
doit()
{
    echo
    ssh root@10.0.0.10 date
    date +%Y-%m%d-%H:%M:%S
    sudo lsof -n -i @10.0.0.10
    sleep 5
}

while [ 1 ]
do
    doit
done
