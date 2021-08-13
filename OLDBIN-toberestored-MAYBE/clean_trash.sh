#!/bin/sh
find /home/bbyers/.trash -mtime +100 -exec /bin/rm {} \;
