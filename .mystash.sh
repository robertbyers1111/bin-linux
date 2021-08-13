#!/bin/bash

# Copies a file to my (non-git) stash directory. Filename is modified with a timestamp

[ $# -lt 1 ] && { echo USAGE: `basename $0` file..; exit; }

NOW=`date +%Y-%m%d-%H%M%S`
MYSTASHDIR=~/.mystash
[ ! -d $MYSTASHDIR ] && mkdir -p $MYSTASHDIR

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
extensionFinder()
{
    FILENM=$*
    EF_DIRNAME=`dirname $FILENM`
    EF_BASENM0=`basename $FILENM`
    case $EF_BASENM0 in
        *.sh) EXTENSARG=" -s .sh" ;;
        *.py) EXTENSARG=" -s .py" ;;
        *.gz) EXTENSARG=" -s .gz" ;;
        *.tar) EXTENSARG=" -s .tar" ;;
        *) EXTENSARG="" ;;
    esac
    EF_BASENM1=`basename $EXTENSARG $FILENM`
    EF_EXTENS=`echo $EF_BASENM0 | sed "s/${EF_BASENM1}.//"`
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

for FNM in $*
do
    extensionFinder $FNM
    NEWNAME=${MYSTASHDIR}/${EF_BASENM1}_${NOW}.${EF_EXTENS}
    CMD="cp $FNM $NEWNAME"
    echo Stashing `basename $FNM` " --> " `echo $NEWNAME | sed 's/.home.rbyers/~/'`
    $CMD
done

