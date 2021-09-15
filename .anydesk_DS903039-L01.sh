#!/bin/bash
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Launch an anydesk session to my mediatek laptop using its IP and port number
#
# Anydesk CLI supports the following..
#
#    --file-transfer
#    --fullscreen
#    --plain (i.e., no window title and toolbar)
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MEDIATEK_PC_IPADDR=10.0.0.19
MEDIATEK_PC_TCPPORT=5977
ANYDESK_OPTIONS="$*"
CMD="anydesk ${ANYDESK_OPTIONS} ${MEDIATEK_PC_IPADDR}:${MEDIATEK_PC_TCPPORT}"
echo $CMD
$CMD &

