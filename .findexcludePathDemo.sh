#!/bin/bash
cat <<EOF

Insert this clause...

    -path <path> -prune -false

Example...

                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    find ~/rabbit  -path ~/rabbit/logs -prune -false  -o -type f -ls
                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

NOTE...

    The path to be pruned MUST be exactly as traversed by the find command!!!

    NOT OK...

        find . -path .git -prune -false
        find /usr -path share -prune -false
        find ~/rabbit -path logs -prune -false

    OK...

        find . -path ./git -prune -false
        find /usr -path /usr/share -prune -false
        find ~/rabbit -path ~/rabbit/logs -prune -false

For multiple excluded paths...

    find / -path /dev -prune -false \
        -o -path /mnt -prune -false \
        -o -path /media -prune -false \
        -o -path /proc -prune -false \
        -type f

EOF
