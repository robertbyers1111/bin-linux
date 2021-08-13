#!/bin/bash

if [ $# -eq 1 ]; then
  USERQUERY=$1
else
  USERQUERY=$LOGNAME
fi

OFMT="ktty8,pid -ouser,pid,ppid,pgid,tty8,start,cputime,rss,%mem,pagein,command"
COLS=`stty -a |head -1 |sed 's/.*columns \([0-9][0-9]*\).*/\1/'`

echo
ps -p65535 $OFMT | sed 's/RUSER/USER /' | head -1 | cut -c-$COLS

echo
ps -U$USERQUERY $OFMT --no-headers \
 | sed 's@ --nowarn@@' \
 | sed 's@ --nogui@@' \
 | sed 's@ --db@@' \
 | sed 's@/bin/bash /home/rbyers/bin/@\~rbyers/bin/@' \
 | sed 's@/usr/bin/unity-scope-loader applications/applications.scope .*@unity-scope-loader applications.scope..@' \
 | egrep -v "bus-daemon" \
 | egrep -v "compiz" \
 | egrep -v "deja-dup" \
 | egrep -v "nm-applet" \
 | egrep -v "telepathy-indicator" \
 | egrep -v "update-notifier" \
 | egrep -v "update-manager" \
 | egrep -v "upstart-" \
 | egrep -v "zeitgeist-datahub" \
 | egrep -v "/usr/lib/at-spi2-core/at-spi-bus-launcher" \
 | egrep -v "/usr/lib/dconf/dconf-service" \
 | egrep -v "/usr/lib/evolution" \
 | egrep -v "/usr/lib/gvfs/gvfs-" \
 | egrep -v "/usr/lib/gvfs/gvfsd-" \
 | egrep -v "/usr/lib/ibus/ibus-" \
 | egrep -v "/bin/bash .*/home/rbyers/cron/cron_keepNFSalive.sh" \
 | egrep -v "rbyers[ 	][ 	]*[0-9][0-9]*[ 	][ 	]*[0-9][0-9]*[ 	][ 	]*[0-9][0-9]*[ 	][ 	]*\?        ..:..:.. ..:..:..[ 	][ 	]*[0-9][0-9]*[ 	][ 	]*[0-9\.][0-9\.]*[ 	][ 	]*[0-9][0-9]* sleep [0-9]([0-9]|)$" \
 | egrep -v "/usr/lib/telepathy" \
 | egrep -v "/usr/lib/unity" \
 | egrep -v "/usr/lib/x86_64-linux-gnu" \
 | egrep -v " su - rbyers -p -s /bin/bash -c cd /home/rbyers/.* source /etc/profile_akatest && exec /bin/bash --rcfile /etc/profile_akatest" \
 | egrep -v "$OFMT" \
 | cut -c-$COLS \
 | egrep -v "egrep| cut -c-| 0.0      0 sed s| /usr/lib/|/usr/bin/pulseaudio| nautilus -n$| dbus-launch --autolaunch" \

echo

