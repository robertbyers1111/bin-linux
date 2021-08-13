#!/bin/sh

NOW=`NOW`
while [ $# -gt 0 ]
do

  FILE=$1
  PATH=`pwd`
  PATH=`echo $PATH | /bin/sed 's#/home/bbyers/##'`
  PATHFILE=$PATH/$FILE
  DOSPATH=`echo $PATH | /bin/sed 's#^#C:\\\Users\\\bbyers\\\Acme Packet\\\#'`
  DOSPATH=`echo $DOSPATH | /bin/sed 's#/#\\\#g'`

  #echo -e "\nbbback \"$DOSPATH\" \"$FILE\" $NOW"
  #echo -e "\npscp -p -agent bbyers@172.30.11.55:$PATH/$FILE \"$DOSPATH\\$FILE\""
  #echo -e "\ncurl ftp://bbyers:abc123@172.30.10.15$PATH/$FILE -o $FILE"
  #echo -e "\nwater put \"$DOSPATH\\$FILE\""

   echo -e "\nwater get \"$PATH/$FILE\""

  shift

done
echo ""
