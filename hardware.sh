#!/bin/bash

# Various ways to list hardware
# 
# Favorites..
# 
# [GUI]
#    kinfocenter
#
# [cmdline]
#
#    inxi -Fx
#    hwinfo                     #(>15k lines)
#    hwinfo --all               #(~1000 lines)
#    hwinfo --short             #(<100 lines)
#
#    hwinfo --short --<ITEM>
# 
#         ITEM is one of ..
# 
#         all, arch, bios, block, bluetooth, braille, bridge, camera, cdrom, chipcard,  cpu,  disk,  dsl,  dvb,  fingerprint,  floppy,
#         framebuffer, gfxcard,  hub,  ide,  isapnp, isdn, joystick, keyboard, memory, mmc-ctrl, modem, monitor, mouse, netcard,
#         network, partition, pci, pcmcia, pcmcia-ctrl, pppoe, printer, redasd, reallyall, scanner, scsi, smp, sound, storage-ctrl,
#         sys, tape, tv, uml,  usb,  usb-ctrl,  vbe,  wlan, xen, zip
# 
# 
# # Others
# 
#     dmidecode
#     free -m
#     hwloc-ls
#     lsblk
#     lsb_release -a
#     lscpu
#     lshw
#     lspci
#     uname -a
# 
#     cat /proc/cpuinfo
#     cat /proc/meminfo
#     cat /proc/interrupts
# 
# Also 'dmesg' to display all messages from the kernel ring buffer
# 
#     dmesg
#     dmesg --facility=kern,user,etc. (see below)
#     dmesg --level=emerg,alert,crit,err
#     dmesg --level=warn,notice
# 
#         Supported log facilities:
#             kern - kernel messages
#             user - random user-level messages
#             mail - mail system
#           daemon - system daemons
#             auth - security/authorization messages
#           syslog - messages generated internally by syslogd
#              lpr - line printer subsystem
#             news - network news subsystem
#         
#         Supported log levels (priorities):
#            emerg - system is unusable
#            alert - action must be taken immediately
#             crit - critical conditions
#              err - error conditions
#             warn - warning conditions
#           notice - normal but significant condition
#             info - informational
#            debug - debug-level messages

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
doit()
{
    export TIMEFORMAT=%3lR
    TMPF=`mktemp`
    echo
    echo x=:================================================================================================================================
    date +"[%Y-%m%m-%H%M%S.%3N] CMD x=: $*"
    ( time $* ) 2>&1 > $TMPF 2>&1
    echo Output lines x=: `cat $TMPF | wc -l`
    echo Elapsed time x=: `grep -E "^[0-9][0-9]*m[0-9][0-9]*\.[0-9][0-9]*s$" $TMPF`
    echo
    cat $TMPF
    rm $TMPF
    echo EOT
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ***  M A I N  ***

doit dmidecode
doit free -m
doit lsblk
doit lscpu
doit lshw
doit lspci
doit dmesg

# for bluetooth troubleshooting
bluetoothctl show
bluetoothctl devices

# for audio troubleshooting
doit pa-info

# some of these take ~6 sconds ('--dsl' and '--pppoe') (which means also '', '--all', and '--reallyall')

doit hwinfo
doit hwinfo --all
doit hwinfo --arch
doit hwinfo --bios
doit hwinfo --block
doit hwinfo --bluetooth
doit hwinfo --braille
doit hwinfo --bridge
doit hwinfo --camera
doit hwinfo --cdrom
doit hwinfo --chipcard
doit hwinfo --cpu
doit hwinfo --disk
doit hwinfo --dsl
doit hwinfo --dvb
doit hwinfo --fingerprint
doit hwinfo --floppy
doit hwinfo --framebuffer
doit hwinfo --gfxcard
doit hwinfo --hub
doit hwinfo --ide
doit hwinfo --isapnp
doit hwinfo --isdn
doit hwinfo --joystick
doit hwinfo --keyboard
doit hwinfo --memory
doit hwinfo --mmc-ctrl
doit hwinfo --modem
doit hwinfo --monitor
doit hwinfo --mouse
doit hwinfo --netcard
doit hwinfo --network
doit hwinfo --partition
doit hwinfo --pci
doit hwinfo --pcmcia
doit hwinfo --pcmcia-ctrl
doit hwinfo --pppoe
doit hwinfo --printer
doit hwinfo --redasd
doit hwinfo --reallyall
doit hwinfo --scanner
doit hwinfo --scsi
doit hwinfo --smp
doit hwinfo --sound
doit hwinfo --storage-ctrl
doit hwinfo --sys
doit hwinfo --tape
doit hwinfo --tv
doit hwinfo --uml
doit hwinfo --usb
doit hwinfo --usb-ctrl
doit hwinfo --vbe
doit hwinfo --wlan
doit hwinfo --xen
doit hwinfo --zip

# [inxi]
#
# Special handling for inxi..
#
# 3.0 version of inxi sometimes would peg CPU (load avg 18!!!) without end,
# so only run the one I've installed in my own path (which is newer)

[ -x /home/rmbjr60/.local/src/inxi/inxi ] && INXI=/home/rmbjr60/.local/src/inxi/inxi || INXI=inxi
[ ! _$INXI = _inxi ] && doit $INXI -Fx || echo OLD INXI VERSION `inxi --version | grep ... | head -1`

