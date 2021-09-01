#!/bin/bash
cat <<EOF

    git branch rabbit-dev
    git pull
    git checkout -b rbyers/rabbit-ticketNumber-ticketTitle
    git push origin rbyers/rabbit-ticketNumber-ticketTitle
    git branch --set-upstream-to=origin/rbyers/rabbit-ticketNumber-ticketTitle

EOF
