#!/bin/sh

. /home/bbyers/lib/bbyerslib.sh

MINSIZE=0

doit ()
{

  echo
  echo "=== $VAR"

  lsOutput=`/bin/ls -l --full-time $VAR`

     TEMPFILESZ=`echo $lsOutput | sed "s/^$PERMS$SPACES$NUMS$SPACES$ALPHANUMS$SPACES$ALPHANUMS$SPACES\($NUMS\).*/\1/"`
  TEMPTIMESTAMP=`echo $lsOutput | sed "s/^$PERMS$SPACES$NUMS$SPACES$ALPHANUMS$SPACES$ALPHANUMS$SPACES$NUMS$SPACES\(20$NUM$NUM-$NUM$NUM-$NUM$NUM$SPACES$NUM$NUM:$NUM$NUM:$NUM$NUM\).*/\1/"`

  echo "    file size: `echo $TEMPFILESZ | $BBIN/commify`"
  echo "    timestamp: $TEMPTIMESTAMP"

  if [ $TEMPFILESZ -ge $MINSIZE ]; then

      SHARKPID=`grep $VAR $TMPF | grep ^wireshark | head -1 |\
       sed "s/^wireshark$SPACES\($NUMS\)${SPACES}root${SPACES}.*/\1/"`


      if [ "$SHARKPID" = "" ]; then

        echo "    appears to be an orphan :'("

      else

        SIDVAL=`ps -fj -p $SHARKPID | grep -v UID | sed "s/^root$SPACES$NUMS$SPACES$NUMS$SPACES$NUMS$SPACES\($NUMS\)$SPACES.*/\1/"`


        if ( echo $PREV_SID_LIST 2>&1 ) | egrep "$SPACES$SIDVAL$SPACES" > /dev/null ; then
            echo "    wireshark pid and sid: $SHARKPID $SIDVAL (sid $SIDVAL already processed)"
        else
            echo "    wireshark pid and sid: $SHARKPID $SIDVAL"
            ps --sid $SIDVAL -fj |grep :..:...wireshark | cut -c-98 | sort
        fi

        PREV_SID_LIST=". $PREV_SID_LIST $SIDVAL ."

      fi


  else
      echo "    (no further processing required)"
  fi

}

echo
echo Saving lsof output to $TMPF..
sudo lsof > $TMPF
echo ..done with lsof

VARLIST=`/bin/ls -lSr /tmp/wiresharkXXXX* |cut -d/ -f2- | sed 's#^#/#'`
for VAR in $VARLIST ; do
  doit $VAR
done

#for VAR in /tmp/wiresharkXXXX*; do
#  doit $VAR
#done

rm $TMPF
