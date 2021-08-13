#!/bin/bash

sudo find / -type d \
    -path .dbus -prune -false \
 -o -path .pulse -prune -false \
 -o -path boot -prune -false \
 -o -path dev -prune -false \
 -o -path lost+found -prune -false \
 -o -path media -prune -false \
 -o -path mnt -prune -false \
 -o -path mtklib -prune -false \
 -o -path mtkmacro -prune -false \
 -o -path mtkoss -prune -false \
 -o -path mtkpdk -prune -false \
 -o -path mtkspice -prune -false \
 -o -path mtktech -prune -false \
 -o -path mtktf -prune -false \
 -o -path mtktools -prune -false \
 -o -path nobackup -prune -false \
 -o -path restore -prune -false \
 -o -path tmp -prune -false \
 -o -path usr -prune -false \
 -o -path workspace -prune -false \
 -type d -print

