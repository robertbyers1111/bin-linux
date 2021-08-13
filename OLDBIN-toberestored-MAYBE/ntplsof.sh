#!/bin/bash

ntppid=`/etc/rc2.d/S58ntpd status | sed 's/[^0-9][^0-9]*\([1-9][0-9]*\)[^0-9][^0-9]*/\1/'`
echo NTP pid is $ntppid

sudo lsof -np$ntppid

