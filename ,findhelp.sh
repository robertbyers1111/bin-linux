#!/bin/bash
cat <<EOF

# EXAMPLE: Find all files named 'xxx' modified in the last 60 seconds

  ( sudo find / -xdev -type f -mmin -60 \\
    -name xxx \\
    -o -path /boot -prune -false \\
    -o -path /cdrom -prune -false \\
    -o -path /dev -prune -false \\
    -o -path /lost+found -prune -false \\
    -o -path /media -prune -false \\
    -o -path /mnt -prune -false \\
    -o -path /proc -prune -false \\
    -o -path /timeshift -prune -false \\
  ) 2>&1 \\
  | grep -v "Permission denied" \\
  | cut -c-$((`tput cols`-1))

EOF

