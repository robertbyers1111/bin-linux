#!/bin/bash
#
# The purpose of this script is to calculate a timeoffset from a particular date/time value and display
# the result as either UNIX Epoch Time in seconds or a human-readable date/time.
#
# USAGE:
#
#       .secondsAgo.sh [-h] | basetimestamp OffsetSecondsStart [OffsetSecondsEnd]
#
# basetimestamp       The starting time from which the offset is to be calculated. May be specified in any
#                     format that /bin/date can understand. A few special values are supported as well. Initially,
#                     the only supported special value is 'now'. Others may be added in the future.
#
# OffsetSecondsStart  Seconds from the current system time to calculate and display. Positive seconds
#                     calculates time into the future, negative seconds calculates time in the past.
#
# OffsetSecondsEnd    We will count down (or up) from the starting offset until this number of seconds
#                     have been displayed. Default is 0 (i.e., display only one data point and exit)
#
# -h                  Display output in a human-readable form. Otherwise, output is in unix epoch seconds.

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
USAGE() {
    [ "$*" != "" ] && { echo; echo ERROR: $*; }
    echo
    echo Usage..
    echo "    `basename $0` [-h] | baseDateTime OffsetSecondsStart [OffsetSecondsEnd]"
    echo
    exit
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
RequireArgCount() {
    OBSERVED_COUNT=$1
    MIN_EXPECTED=$2
    [ $# -eq 2 ] && MAX_EXPECTED=$2 || MAX_EXPECTED=$3
    [ $OBSERVED_COUNT -lt $MIN_EXPECTED ] && USAGE Too few args [$OBSERVED_COUNT] on command line, or invalid option specified
    [ $OBSERVED_COUNT -gt $MAX_EXPECTED ] && USAGE Too many args [$OBSERVED_COUNT] on command line, or invalid option specified
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   ***  M A I N  ***

# Check for '-h' option on command line
[ "$1" = "-h" ] && { HUMAN_READABLE=1; shift; } || HUMAN_READABLE=0

# Now there should be exactly two cmd line args remaining
RequireArgCount $# 2 3

# Convert basetime from command line into a UNIX Epoch Time
BASEDATETIME="$1"
UNIX_EPOCH_TIME_0=`date -d "$1" +%s`
[ $? -ne 0 ] && { echo ERROR From date command while trying to process "$1" from command line; exit; }

# Make sure the second command line argument is valid
START=`echo "$2" | grep -E "^[-]*[0-9][0-9]*$"`
[ $? -ne 0 ] && { echo ERROR Unable to parse time offset from command line: "$2"; exit; }

# Make sure the last command line argument is valid
END=${!#}
[ _$END = _ ] && END=0
END=`echo "$END" | grep -E "^[-]*[0-9][0-9]*$"`
[ $? -ne 0 ] && { echo ERROR Unable to parse time offset from command line: "$END"; exit; }

# Figure out direction of delta
[ $? -eq 0 ] && OP="" || OP="+"

         echo START:$START
         echo END:$END
         echo OP:$OP
         exit

I=$START
while [ $I -ne $END ]
do
    # Calculate the new time
    UNIX_EPOCH_TIME_1=$(($UNIX_EPOCH_TIME_0$OP$I))

    # Display new time (format is hard-coded. TO DO: could make this flexible)
    date -d @$UNIX_EPOCH_TIME_1 +"%b %_d %T"
done









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
