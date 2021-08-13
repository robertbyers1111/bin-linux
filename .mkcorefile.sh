#!/bin/bash

ROBOT_USER=root
ROBOT_NAV_IPPADDR=10.0.0.10

doit ()
{
    echo
    date
    NOW=`date +%s`
    #sh $ROBOT_USER@$ROBOT_NAV_IPPADDR truncate -s 2M /data/logs/core.rbyers_test.12345.iRobot-2826159D6CCB4697AC8055BC5DDFFD5E.$NOW
    ssh $ROBOT_USER@$ROBOT_NAV_IPPADDR cp /usr/bin/gdb /data/logs/core.rbyers_test.12345.iRobot-2826159D6CCB4697AC8055BC5DDFFD5E.$NOW
    ssh $ROBOT_USER@$ROBOT_NAV_IPPADDR truncate -s 0 /data/logs/core.rbyers_test.12345.iRobot-2826159D6CCB4697AC8055BC5DDFFD5E.$NOW.dbgrdone
    ssh $ROBOT_USER@$ROBOT_NAV_IPPADDR ls -otr /data/logs/core*
}

while [ 1 ]
do
    doit
    sleep 4 ; date
    sleep 4 ; date
    sleep 4 ; date
    sleep 4 ; date
    sleep 4 ; date
    sleep 4 ; date
    sleep 4 ; date
    sleep 4 ; date
    sleep 4 ; date
    sleep 4 ; date
    sleep 4 ; date
done
