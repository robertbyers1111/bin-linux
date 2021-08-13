#!/bin/bash
shopt -s nocasematch
case `hostname` in

    rmbinspiro2018) df -h -t ext4 -t fuseblk -t fuse.ssh
    ;;

    rb-el6-6283767) df -h -t ext4 -t nfs -t fuse.ssh
    ;;

    irbt-8758l) df -h -t ext4 -t fuse.sshfs
    ;;

    *) echo unknown host `hostname`
    ;;

esac
