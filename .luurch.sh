#!/bin/bash
ROBOT_USER=root
ROBOT_DART_IPADDR=10.0.0.12
ROBOT_NAV_IPADDR=10.0.0.10
[ $# -eq 0 ] && {
    HOST_OR_IPADDR=$ROBOT_DART_IPADDR
} || {
    echo $1 | grep -iq nav
    [ $? -eq 0 ] && HOST_OR_IPADDR=$ROBOT_NAV_IPADDR || { echo Usage: `basename $0` [nav] ; exit ; }
}

ssh $ROBOT_USER@$HOST_OR_IPADDR
