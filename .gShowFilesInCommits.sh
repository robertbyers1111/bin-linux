#!/bin/bash

# Displays the files affected by the last several commits to the current branch

COMMITS=32
COMMIT_IDS=`git log --oneline | head -$COMMITS | awk '{ printf "%s\n",$1 }'`

cat<<EOT

        Running "git show --pretty='' --name-only" for each commit

EOT

for COMMIT_ID in $COMMIT_IDS
do
    echo
    echo "=== COMMIT $COMMIT_ID"
    git show --pretty="" --name-only $COMMIT_ID
done

