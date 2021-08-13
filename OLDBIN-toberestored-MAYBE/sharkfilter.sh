#!/bin/bash

#----------------------------------------------------------------------------------
#
# This script displays wireshark commands, with filters, for capturing
# traffic within a user's anvil dynamic IP range, as well as for traffic
# to/from the user's current anvil rig.
#
# The filters will be specific to a user's range. No traffic from other users
# will be captured when these filters are used (!)
#
# NOTE: For the management network, the filter will be for the mgmt IP of your
#       current anvil rig (from environment variable 'AUTO_RIGSETUP')
#
#
# Assumptions:
#
# 1) You'll be launching wireshark from one of SQA's *water linux hosts.
#
#    This, in turn, satisfies these additional assumptions:
#
#         A) eth0 is the lab mgmt network
#         B) eth1 is the 172.16 net
#         C) eth2 is the 182.16 net
#         D) eth3 is the 172.168 net
#
# 2) You have a .anvilrc file with a {dynamicip} section, similar to this:
#
#         {dynamicip}
#         subnet 192.168.0.0 netmask 255.255.0.0 {
#           range 192.168.212.240 192.168.212.255;
#         }
#         subnet 182.16.0.0 netmask 255.255.0.0 {
#           range 182.16.212.240 182.16.212.255;
#         }
#         subnet 172.16.0.0 netmask 255.255.0.0 {
#           range 172.16.212.240 172.16.212.255;
#         }
#         subnet 192.169.0.0 netmask 255.255.0.0 {
#           range 192.169.212.240 192.169.212.255;
#         }
#
# 3) Environment variable AUTO_RIGSETUP is set. This is required only
#    for the lab mgmt network filter.
#
# bbyers, Aug 2015
#----------------------------------------------------------------------------------

. $HOME/lib/bbyerslib.sh

RIG_SETUP_FILE=$AUTO_RIGSETUP

if [ x$ANVIL_RCFILE != x ]; then
  ANVILRC_FILE=$ANVIL_RCFILE
elif [ x$ANVILRC != x ]; then
  ANVILRC_FILE=$ANVILRC
else
  ANVILRC_FILE=~/.anvilrc
fi

case $# in

  0) :
  ;;

  1) if echo $1 | egrep -q setup; then
       RIG_SETUP_FILE=$1
     elif echo $1 | egrep -q anvilrc; then
       ANVILRC_FILE=$1
     else
       echo "ERROR: I do not know if '$1' is a rig setup file or an anvilrc file"
       exit
     fi
  ;;

  2) I=1
     while [ $I -le 2 ]; do
       if echo $1 | egrep -q setup; then
         RIG_SETUP_FILE=$1
       elif echo $1 | egrep -q anvilrc; then
         ANVILRC_FILE=$1
       else
         echo "ERROR: I do not know if '$1' is a rig setup file or an anvilrc file"
         exit
       fi
       shift
       I=`expr $I + 1`
     done
  ;;

  *) echo "USAGE: `basename $0` [anvilrc_file] [rig_setup_file]"
     exit
  ;;

esac

if [ ! -f $ANVILRC_FILE ]; then
  echo $ANVILRC_FILE NOT EXIST
  exit
fi

if [ ! -f $RIG_SETUP_FILE ]; then
  echo $RIG_SETUP_FILE NOT EXIST
  exit
fi

for SUB in 10.196 172.16 182.16 192.168; do

  case $SUB in
    10.196) INTF=eth0
    ;;
    172.16) INTF=eth1
    ;;
    182.16) INTF=eth2
    ;;
    192.168) INTF=eth3
    ;;
    *) echo SUB is $SUB, WTF\?
    exit
    ;;
  esac

  if [ $INTF = eth0 ]; then

    WANCOM0_IP=`egrep wancom0_ip= $RIG_SETUP_FILE | egrep -v secondary | sed "s/.*=${ZSPACES}//" | sed "s/${SPACES}.*//"`
    YOUR_RIGNAME=`basename $RIG_SETUP_FILE | sed 's/.setup//'`

    if egrep -q dut:9200 $RIG_SETUP_FILE ; then
      SLASH=/30
    else
      SLASH=""
    fi

    echo
    echo "Mgmt traffic to/from $YOUR_RIGNAME"
    echo
    echo "   sudo wireshark -i $INTF -a filesize:102400 -f \"host ${WANCOM0_IP}${SLASH}\""

  else

    echo
    echo $SUB network
    echo
    echo "   sudo wireshark -i $INTF -a filesize:102400 -f \"net (`$BBIN/sharksubs.sh $SUB $ANVILRC_FILE`)\""

  fi

done

echo
