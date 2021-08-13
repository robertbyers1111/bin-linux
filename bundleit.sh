#!/bin/bash
BASE=sys32_0
doit()
{
    uuencode $1 $1 > $2.cache
    tar czvf $2.tgz $2.cache
}
doit $1 ${BASE}0

for I in 0 1 2 3 4 5 6 7 8
do
    J=`echo $I 1+p | dc`
    echo I:$I, J:$J
    [ -f ${BASE}{$I}.tgz ] && doit ${BASE}{$I}.tgz ${BASE}{$J}
done
