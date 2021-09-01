#!/bin/bash
#
# Search the entire local filesystem (with certain exclusions)
#
# This version is for Mediatek
#
# 2021-0826 NOT WORKING! (does nothing)

sudo find /admin /bin /etc /home/rbyers /lib* /opt /root /sbin /srv /usr /var -xdev \
    -path /home/rbyers/.cache -prune -false \
 -o -path /home/rbyers/.eclipse -prune -false \
 -o -path /home/rbyers/.m2 -prune -false \
 -o -path /home/rbyers/.snapshot -prune -false \
 $*

