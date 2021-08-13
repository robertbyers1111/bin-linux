#!/bin/sh

echo try vpnui instead
exit

# OLD PRE-OKTA USING OPENCONNECT (no longer supported)

printf "\033]0;`date +--[VPN]--\ \(%H:%M:%S\)`\007\003\""
OPENC_CMD="openconnect"
OPENC_AUTHGROUP="--authgroup=iRobot-VPN"
OPENC_USER="--user=rbyers"
OPENC_HOST="vpn.irobot.com"
OPENC_OPTS="-v --timestamp"
CMD="sudo $OPENC_CMD $OPENC_OPTS $OPENC_AUTHGROUP $OPENC_USER $OPENC_HOST"
echo $CMD
$CMD

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# (these are in staticroutes.sh)
#
# ip route add 3.0.0.0/8 via 10.0.0.1 dev wlp1s0
# ip route add 35.240.128.0/17 via 10.0.0.1 dev wlp1s0
# ip route add 104.28.0.0/17 via 10.0.0.1 dev wlp1s0
# ip route add 146.112.0.0/12 via 10.0.0.1 dev wlp1s0
# ip route add 151.101.0.0/17 via 10.0.0.1 dev wlp1s0
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
