#!/bin/bash
# Launch an anydesk session to my mediatek laptop using its IP and port number
MEDIATEK_PC_IPADDR=10.0.0.28
MEDIATEK_PC_TCPPORT=5977
CMD="anydesk ${MEDIATEK_PC_IPADDR}:${MEDIATEK_PC_TCPPORT}"
echo $CMD
$CMD &

