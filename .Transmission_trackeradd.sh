#!/bin/bash
#
# NOTES
# For selecting a torrent ('-t') use the torrent ID (col 1) from output of 'transmission-remot -l'

TR_EXEC="/usr/bin/transmission-remote"
TEMP=`mktemp`

NEW_TRACKERS=`curl -fs --url https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best_ip.txt | grep .`
for NEW_TRACKER in $NEW_TRACKERS
do
    echo NEW_TRACKER: $NEW_TRACKER
done

add_tracker()
{
    echo
    echo add_tracker $1
    for NEW_TRACKER in $NEW_TRACKERS
    do
        echo NEW_TRACKER: $NEW_TRACKER
        $TR_EXEC -t $1 -td $NEW_TRACKER
    done
    $TR_EXEC -t $1 -it
}

TORRENTS="3 6 12 14 32 45"
for TORRENT in $TORRENTS
do
    add_tracker $TORRENT
done

