#!/bin/bash
#
# Sends all the command line args to 'dc' (preceeding with directives
# for displaying to two decimal places ('2k') and printing the result ('p')

# Example:
#
#     .dc.sh 8k 2199115 700000/
#
# (the '8k' overrides the default '2k' but is not required)

[ "$PUBLIC_HTML" = "" ] && {
    [ "$BBHOME" = "" ] && {
        [ "$HOSTNAME" = "" ] && {
            HOSTNAME=`hostname`
        }
        case $HOSTNAME in
            RmbInspiro2018) export BBHOME=/home/rmbjr60 ;;
            *) export BBHOME=/home/rbyers ;;
        esac
    }
    export PUBLIC_HTML=$BBHOME/public_html
}

[ $# -eq 0 ] && {
    cat $PUBLIC_HTML/unix/dc.txt
    exit -1
}

echo echo 2k $* p \| dc
echo 2k $* p | dc

