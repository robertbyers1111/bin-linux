#!/bin/bash
DARTUSER=root
DARTIP=10.0.0.12
LOGGER_DIR=/opt/irobot/bin
CHECK_LOGGER=/opt/irobot/bin/check_logger.sh
ssh -T $DARTUSER@$DARTIP <<EOF
    cd $LOGGER_DIR
    $CHECK_LOGGER
EOF

