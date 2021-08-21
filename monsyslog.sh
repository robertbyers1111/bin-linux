#!/bin/bash

# The purpose of this script is to display records from /var/log/syslog that were generated within the most recent time-window

# (1) Create a file with consecutive timestamps in 1 second increments starting LOOKBACK_SECONDS ago up to the present time
# (2) Use the file from (1) as grep patterns to find all syslog records from that time window

    SYSLOG=/var/log/syslog
    TEMP_FILE1=`mktemp`
    TEMP_FILE2=`mktemp`
    NOW=`date +"%b %_d %T"`

# Create a file with all the timestamps of interest

    for I in {0..30}
    do
        ~/bin/.secondsAgo.sh "$NOW" -$I >> $TEMP_FILE2
    done

# Find all the interesting messages in /var/log/syslog

    grep -Ev "l systemd|l kernel|l anacron|l whoopsie|l acvpnui|l dbus-daemon|l nm-dispatcher|l terminator|l CRON|l gnome-shell|l org.gnome.Shell" $SYSLOG 2>&1 | grep -Ev "Binary file .*matches" > $TEMP_FILE1

# Keep only the messages with timestamps of interest

    grep --file=$TEMP_FILE2 $TEMP_FILE1 | cut -c-188

# For debugging, we only remove the temp files it the special file does not exist

    if [ ! /tmp/DoNotRemoveTempFiles.debug ]; then
        [ -f $TEMP_FILE1 ] && rm $TEMP_FILE1
        [ -f $TEMP_FILE2 ] && rm $TEMP_FILE2
    else
        echo TEMP_FILE1:$TEMP_FILE1
        echo TEMP_FILE2:$TEMP_FILE2
    fi

