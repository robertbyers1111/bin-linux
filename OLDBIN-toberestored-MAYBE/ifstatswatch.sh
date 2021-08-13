#!/bin/bash

# This script enters an infinite loop in which the RX and TX packet and byte deltas are computed and displayed

INTF=wlp1s0
INTERVAL=5 # seconds
KILLFILE=/tmp/ifstatswatch.die

while [ 1 ]
do

  NOW=`date +%Y-%m%d-%H:%M:%S`
  printf '%s ' $NOW

  IFSTATS=`ifconfig $INTF | grep -E "RX packets|RX bytes|TX packets|TX bytes"`

  RXPKTS0=$RXPKTS1
  RXPKTS1=`echo $IFSTATS | sed 's/.*RX packets[ 	]*:[ 	]*\([0-9][0-9]*\)[ 	].*/\1/'`
  if [ x$RXPKTS0 != x ]; then
    DELTA=`expr $RXPKTS1 - $RXPKTS0`
    RATE=`echo 2k $DELTA $INTERVAL /p | dc`
    printf '[RX] %7d pkts %10.1f/sec' $DELTA $RATE
  fi

  RXBYTES0=$RXBYTES1
  RXBYTES1=`echo $IFSTATS | sed 's/.*RX bytes[ 	]*:[ 	]*\([0-9][0-9]*\)[ 	].*/\1/'`
  if [ x$RXBYTES0 != x ]; then
    DELTA=`expr $RXBYTES1 - $RXBYTES0`
    RATE=`echo 2k $DELTA $INTERVAL /p | dc`
    printf '%9d bytes %10.1f/sec' $DELTA $RATE
  fi

  printf '     '

  TXPKTS0=$TXPKTS1
  TXPKTS1=`echo $IFSTATS | sed 's/.*TX packets[ 	]*:[ 	]*\([0-9][0-9]*\)[ 	].*/\1/'`
  if [ x$TXPKTS0 != x ]; then
    DELTA=`expr $TXPKTS1 - $TXPKTS0`
    RATE=`echo 2k $DELTA $INTERVAL /p | dc`
    printf '[TX] %7d pkts %10.1f/sec' $DELTA $RATE
  fi

  TXBYTES0=$TXBYTES1
  TXBYTES1=`echo $IFSTATS | sed 's/.*TX bytes[ 	]*:[ 	]*\([0-9][0-9]*\)[ 	].*/\1/'`
  if [ x$TXBYTES0 != x ]; then
    DELTA=`expr $TXBYTES1 - $TXBYTES0`
    RATE=`echo 2k $DELTA $INTERVAL /p | dc`
    printf '%9d bytes %10.1f/sec' $DELTA $RATE
  fi

  echo # force a newline

  # If someone creates this file, we exit

  [ -f $KILLFILE ] && {
    echo $KILLFILE exists. Shutting down...
    rm $KILLFILE
    exit
  }

  sleep $INTERVAL
done

