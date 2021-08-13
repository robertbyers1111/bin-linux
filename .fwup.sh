#!/bin/bash
OTANAME=$1
NAVIPADDR=10.0.0.10
DESTPATH=/opt/irobot/persistent/maps
[ $# -ne 1 ] && { echo USAGE: `basename $0` OTA_filename ; exit ; }
[ ! -f $OTANAME ] && { echo $OTANAME not exist ; exit ; }
echo Running: scp $OTANAME root@$NAVIPADDR:$DESTPATH
scp $OTANAME root@$NAVIPADDR:$DESTPATH
cat <<EOF
Now you run these commands on nav...
ssh root@$NAVIPADDR
cd /data
sei.sh -f /opt/irobot/persistent/maps/$OTANAME
EOF

