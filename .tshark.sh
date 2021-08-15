#!/bin/bash

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Launch tshark with my favorite settings
#
# NOTE: Lots 'sudo' here. Works best if no password is required for current user to run sudo commands
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

IGNOREHOSTS="not host wobhfs02.dsp.eus.mediatek.inc"

TSHARK_HELP=~/public_html/unix/tshark.txt
TSHARK_DIR=~/.tshark
TSHARK_EXT=pcapng
TSHARK_BASE=$TSHARK_DIR/tshark_`date +"%Y-%m%d-%H%M%S_%N"`
TSHARK_OUT=${TSHARK_BASE}.${TSHARK_EXT}
TSHARK_MAXFILES=files:1000
TSHARK_MAXFILESIZE_KB=filesize:50000
TSHARK_FILEOPTS="-a $TSHARK_MAXFILES -b $TSHARK_MAXFILESIZE_KB"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
USAGE()
{
    echo
    echo USAGE:
    echo
    echo "    `basename $0` [-h|--help]"
    echo
    exit
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Make sure output directory is owned by root (but still writeable by me). This is
# because tshark as root can't write to new files unless root has ownership of the
# directory (tshark bug?) Without this bug(?) this function would not be needed.

ownership_kludge()
{
    [ ! -d $TSHARK_DIR ] && mkdir -p $TSHARK_DIR
    sudo chown root:1000 $TSHARK_DIR
    sudo chmod 775 $TSHARK_DIR
    #sudo touch $TSHARK_OUT
    #[ ! -f $TSHARK_OUT ] && { echo ERROR: $TSHARK_OUT either not exist, is not a file; exit; }
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
trap_ctrlc() {
    echo
    echo Whoa! Ctrl-C detected. Killing $pid..
    sudo kill $pid
    [ $? -ne 0 ] && echo Whoa! non-zero exit status from the kill: $?
    wait $pid
    [ $? -ne 0 ] && echo Whoa! non-zero exit status from tshark: $?
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# This function takes the output of 'ip link' and reformats it as a one-line list of all
# currently active non-loopback interfaces, with a "-i" prepended to each interface. This
# is then passed to the tshark cli.
#
# Example input that can be successfully parsed by this function...
#
# % ip --oneline link
#    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN \    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
#    2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP qlen 1000\    link/ether 00:50:56:95:29:33 brd ff:ff:ff:ff:ff:ff

findNetworkInterfaces()
{
    ip --oneline link |\
     grep -Ev "\Wlo:\W" |\
     grep -E "\Wstate\s\s*UP\W" |\
     tr '\n' ' ' |\
     sort -V |\
     sed 's/^\s*[0-9][0-9]*:\s*\([^:][^:]*\).*/-i \1/g'
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# [Since ifconfig is deprecated, no longer using this]
#
#    # This function takes the output of 'ifconfig' and reformats it as a one-line list of all
#    # currently active non-loopback interfaces, with a "-i" prepended to each interface. This
#    # is then passed to the tshark cli.
#    #
#    # EXAMPLE..
#    #
#    #     % ifconig
#    #     cscotun0: flags=4305<UP,POINTOPOINT,RUNNING,NOARP,MULTICAST>  mtu 1390
#    #         inet 10.70.243.153  netmask 255.255.252.0  destination 10.70.243.153
#    #         inet6 fe80::96b7:6ed1:950b:886b  prefixlen 64  scopeid 0x20<link>
#    #         inet6 fe80::5b4e:7eb2:3cc5:cd7e  prefixlen 126  scopeid 0x20<link>
#    #         unspec 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  txqueuelen 500  (UNSPEC)
#    #         RX packets 206701  bytes 103187413 (103.1 MB)
#    #         RX errors 0  dropped 0  overruns 0  frame 0
#    #         TX packets 258508  bytes 227458180 (227.4 MB)
#    #         TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
#    # 
#    #     enxa0cec8150043: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
#    #         inet 10.0.0.26  netmask 255.255.255.0  broadcast 10.0.0.255
#    #         inet6 fe80::5479:2df7:a862:8b5  prefixlen 64  scopeid 0x20<link>
#    #         ether a0:ce:c8:15:00:43  txqueuelen 1000  (Ethernet)
#    #         RX packets 35783244  bytes 21165432947 (21.1 GB)
#    #         RX errors 0  dropped 0  overruns 0  frame 0
#    #         TX packets 152872374  bytes 201037462133 (201.0 GB)
#    #         TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
#    # 
#    #     lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
#    #         inet 127.0.0.1  netmask 255.0.0.0
#    #         inet6 ::1  prefixlen 128  scopeid 0x10<host>
#    #         loop  txqueuelen 1000  (Local Loopback)
#    #         RX packets 6831246  bytes 198865067468 (198.8 GB)
#    #         RX errors 0  dropped 0  overruns 0  frame 0
#    #         TX packets 6831246  bytes 198865067468 (198.8 GB)
#    #         TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
#    #
#    # BECOMES..
#    #
#    #    -i cscotun0 -i enxa0cec8150043
#
#    findNetworkInterfaces()
#    {
#        ifconfig | grep flags= | grep "\WUP\W" | grep -v LOOPBACK | cut -d: -f1 | sort | sed 's/^/-i /' | tr '\n' ' ' | sed 's/  *$//'
#    }

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
doit()
{
    echo
    echo "========================================================================================"
    echo % $*
    echo "========================================================================================"
    $* | grep -v ===========================================================
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  ***  M A I N  ***

[ $# -gt 0 ] && {
    case $1 in

        h|-h|--h|help|-help|--help)
            [ -r $TSHARK_HELP ] && cat $TSHARK_HELP || tshark --help
            exit
            ;;

        *)
            echo
            echo "    Extra command line options for tshark: $*"
            ;;
    esac
}

# Discover all active non-loopback interfaces
IFLIST=`findNetworkInterfaces`

# See comments for this function for why it is called
ownership_kludge

#   +-----------------+
#---| Launch tshark.. |---
#   +-----------------+

    CMD="sudo tshark -q $TSHARK_FILEOPTS $IGNOREHOSTS -w$TSHARK_OUT $IFLIST $*"
    echo CMD:$CMD
    $CMD &

# Run tshark until Ctrl-C is pressed..
pid=$!
trap trap_ctrlc INT
wait

# Take ownership of the output file(s)
sudo chown `id -u`:`id -g` ${TSHARK_BASE}*

# Display a summary of what we captured..

for TSHARK_INDIVIDUAL in ${TSHARK_BASE}*
do
    #cho
    #cho tshark -q -zconv,ip  -r $TSHARK_INDIVIDUAL
    echo tshark -q -zconv,tcp -r $TSHARK_INDIVIDUAL
    #cho tshark -q -zconv,udp -r $TSHARK_INDIVIDUAL
    #oit tshark -q -zconv,ip  -r $TSHARK_INDIVIDUAL | head -33
    #oit tshark -q -zconv,tcp -r $TSHARK_INDIVIDUAL | head -33
    #oit tshark -q -zconv,udp -r $TSHARK_INDIVIDUAL | head -33
done

# That is all for now

#echo
#echo #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#echo
#echo tshark completed, packets written to..
#echo
#for TSHARK_INDIVIDUAL in ${TSHARK_BASE}*
#do
#    /bin/ls -lFLANGv --time-style="+%Y-%m-%d %H:%M:%S" $TSHARK_INDIVIDUAL
#done
#echo
