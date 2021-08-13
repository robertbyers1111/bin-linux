#!/bin/sh

if [ $# -ne 0 ]; then
  OPTS="$1"
fi

doit ()
{
  ps $OPTS -o $1 | cut -c-111
}

doit uname,pid,ppid,pgid,longtname,start,cputime,rss,%mem,pagein,command

# doit args         COMMAND
# doit cmd          CMD
# doit command      COMMAND
# doit ucmd         CMD
# doit ucomm        COMMAND

# doit %cpu,%mem,pagein,cputime
# doit dsiz,m_size,rss,size,sz,trss,tsiz,vsize,vsz
# doit euid,fsuid,fuid,ruid,suid,svuid,uid,uid_hack
# doit fuser,ruser,suser,svuser,uname,user
# doit lstart,start,start_time,stime,time
# doit pid,ppid,spid
# doit tty,longtname,tty4,tty8

# === args
#   PID COMMAND
# 20698 sudo tshark -nq -wtsharkout_eth1_141001-140037-769.pcap -ieth1 -f net (172.16.208.116/30 or 172.16.208.120/29
# 
# === cmd
#   PID CMD
# 20698 sudo tshark -nq -wtsharkout_eth1_141001-140037-769.pcap -ieth1 -f net (172.16.208.116/30 or 172.16.208.120/29
# 
# === command
#   PID COMMAND
# 20698 sudo tshark -nq -wtsharkout_eth1_141001-140037-769.pcap -ieth1 -f net (172.16.208.116/30 or 172.16.208.120/29
# 
# === ucmd
#   PID CMD
# 20698 sudo
# 
# === ucomm
#   PID COMMAND
# 20698 sudo
# 
# === %cpu,%mem,pagein,cputime
#   PID %CPU %MEM PAGEIN     TIME
# 20698  0.0  0.0      0 00:00:00
# 
# === dsiz,m_size,rss,size,sz,trss,tsiz,vsize,vsz
#   PID DSIZ  SIZE   RSS    SZ    SZ TRSS TSIZ    VSZ    VSZ
# 20698 92440 23110 2904   748 23110    0    0  92440  92440
# 
# === euid,fsuid,fuid,ruid,suid,svuid,uid,uid_hack
#   PID  EUID FSUID  FUID  RUID  SUID SVUID   UID UID
# 20698     0     0     0     0     0     0     0 root
# 
# === fuser,ruser,suser,svuser,uname,user
#   PID FUSER    RUSER    SUSER    SVUSER   USER     USER
# 20698 root     root     root     root     root     root
# 
# === lstart,start,start_time,stime,time
#   PID                  STARTED  STARTED START STIME     TIME
# 20698 Wed Oct  1 14:00:37 2014 14:00:37 14:00 14:00 00:00:00
# 
# === pid,ppid,spid
#   PID   PID  PPID  SPID
# 20698 20698     1 20698
# 
# === tty,longtname,tty4,tty8
#   PID TT       TTY      TTY  TTY
# 20698 pts/13   pts/13   13   pts/13
# 
