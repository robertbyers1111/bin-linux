#!/bin/bash
# This script mounts the appropriate sshfs for this host

doit()
{
    findmnt --noheadings --types fuse.sshfs $2 > /dev/null 2>&1
    [ $? -eq 0 ] && {
        echo $1 already mounted on \~/`basename $2`
    } || {
        CMD="sshfs $1 $2"
        echo MOUNT $2
        $CMD
        echo MOUNTED: `findmnt --noheadings --types fuse.sshfs $2`
    }
}

case `hostname` in
  IRBT-8758l) doit rmbjr60@10.0.0.6:/home/rmbjr60 /home/rbyers/rmbInspiro2018-mount
      ;;
  RmbInspiro2018) doit irobert@irbt-8758l:/home/rbyers /home/rmbjr60/8758l-mount
      ;;
  *) echo bad hostname! `hostname`
  exit
  ;;
esac
