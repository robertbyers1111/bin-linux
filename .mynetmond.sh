#!/bin/bash

# sudo nmcli monitor sudo nmcli monitor
# sudo nmcli general status
# sudo nmcli networking connectivity check
# sudo nmcli radio all
# sudo nmcli connection show --active
# sudo nmcli device show wlp1s0
# sudo nmcli device wifi list --rescan yes

LOGDIR=~/var/log
CON=connection
DEV=device
MON=monitor
NMON=$MON
CMON=${CON}_${MON}
DMON=${DEV}_${MON}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#       NO      TIMESTAMPS      !!!
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

cd $LOGDIR
screen -L -Logfile nmcli_${NMON}_`now -nc`.log -dmS nmcli_$NMON sudo nmcli monitor
screen -L -Logfile nmcli_${CMON}_`now -nc`.log -dmS nmcli_$CMON sudo nmcli connection monitor
screen -L -Logfile nmcli_${DMON}_`now -nc`.log -dmS nmcli_$DMON sudo nmcli device monitor

