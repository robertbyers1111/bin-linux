#!/bin/bash

# The purpose of this script is to display records from /var/log/syslog that were generated within the most recent time-window

# (1) Create a file with consecutive timestamps in 1 second increments starting LOOKBACK_SECONDS ago up to the present time
# (2) Use the file from (1) as grep patterns to find all syslog records from that time window

SYSLOG=/var/log/syslog
TEMP_FILE1=`mktemp`
TEMP_FILE2=`mktemp`
NOW=`date +"%b %_d %T"`
for I in {0..30}
do
    /home/rbyers/bin/.secondsAgo.sh "$NOW" -$I >> $TEMP_FILE2
done
grep -Ev "l systemd|l kernel|l anacron|l whoopsie|l acvpnui|l dbus-daemon|l nm-dispatcher|l terminator|l CRON|l gnome-shell|l org.gnome.Shell" $SYSLOG 2>&1 | grep -Ev "Binary file .*matches" > $TEMP_FILE1
grep --file=$TEMP_FILE2 $TEMP_FILE1 | cut -c-188
[ -f $TEMP_FILE1 ] && rm $TEMP_FILE1
[ -f $TEMP_FILE2 ] && rm $TEMP_FILE2

