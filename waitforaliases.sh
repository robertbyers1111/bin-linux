#!/bin/bash
MYID=`id -u`
getgvimpid()
{
    GVIMPID=`ps -u$MYID -fj | grep gvim | grep bash_aliases | grep -v grep | awk {'print $2'}`
    return $GVIMPID
}
while [ 1 ]; do
    getgvimpid
    [ $? -eq 0 ] && exit
    sleep 0.5
done
