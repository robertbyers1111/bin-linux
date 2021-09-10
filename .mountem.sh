#!/bin/bash
# This script mounts the appropriate sshfs and NTFS filesystem mounts for this host

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
doit_ntfs()
{
    findmnt --noheadings --types ntfs $1 > /dev/null 2>&1
    [ $? -eq 0 ] && {
        echo $1 already mounted on \~/`basename $1`
    } || {
        CMD="mount $1"
        echo $cmd
        $CMD
        echo MOUNTED: `findmnt --noheadings --types ntfs $1`
    }
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
doit_sshfs()
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

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# *** M A I N ***

case `hostname` in
  RmbInspiro2018)
      doit_sshfs irobert@irbt-8758l:/home/rbyers /home/rmbjr60/8758l-mount
      doit_ntfs /dev/sda3
      ;;
  IRBT-8758l) doit_sshfs rmbjr60@10.0.0.6:/home/rmbjr60 /home/rbyers/rmbInspiro2018-mount
      ;;
  *) echo No mounts to do for `hostname` in `basename $0`
  exit
  ;;
esac
