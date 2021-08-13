#!/bin/bash

if [ $# -ne 1 ]
then
  FNAME=`mktemp -u --tmpdir=. -t .vperl-XXXXXXXX.pl`
else
  FNAME=$1
fi


if ! ( echo $FNAME ) | grep -Eq "\.pl$|\.pm$" ; then
  FNAME=${FNAME}.pl
fi

[ -f $FNAME ] && { echo $FNAME already exists; exit; }

echo FNAME:$FNAME

cat <<EOF > $FNAME
#!/usr/bin/perl -l
use strict;
use warnings;

EOF

vi + $FNAME

