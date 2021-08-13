#!/bin/bash

[ _$RABBIT_HOME = "_" ] && { echo RABBIT_HOME NOT SET; exit; }
echo RABBIT_HOME: $RABBIT_HOME
RABBIT_CONFIG=$RABBIT_HOME/config
TGZ_HOME=~/etc
TGZ_TAIL=ROBOTCFG_and_ENVCFG.tar.gz
DST_ENVCFG=env/ENVCFG.py
DST_ROBOTCFG=robot/ROBOTCFG.py

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
errormsg()
{
    echo
    echo ERROR: $*
    echo
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
copyit()
{
    [ -f $1 ] && {
         echo
         #echo cp -f $1 $2
         cp -f $1 $2
         sha256sum $RABBIT_CONFIG/$1 $RABBIT_CONFIG/$2
    } || {
        errormsg $1 NOT EXIST
    }
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
doit()
{
    echo
    echo PROCESSING $1

    TGZ=$TGZ_HOME/${1}_$TGZ_TAIL
    SRC_ENVCFG=env/${1}_env.py
    SRC_ROBOTCFG=robot/${1}_robot.py

    [ -f $TGZ ] && {
        tar tvf $TGZ
        tar xovf $TGZ | sed 's/^/Extracting /'
        [ _$2 = "_MAKE_ACTIVE" ] && {
            echo
            echo COPYING $1 TO ACTIVE RABBIT CFGS
            copyit $SRC_ENVCFG $DST_ENVCFG
            copyit $SRC_ROBOTCFG $DST_ROBOTCFG
        } || {
            echo Activation not requested for $1
        }
    } || {
        errormsg $TGZ NOT EXIST
    }
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ****  M  A  I  N  ****

[ -d $RABBIT_CONFIG ] && {
    cd $RABBIT_CONFIG
} || {
    errormsg $RABBIT_CONFIG NOT EXIST
}

# The first arg must match part of the tgz file and part of both the env and robot configs inside the tgz file

doit Lucy_soho-379E86
doit luurch MAKE_ACTIVE

