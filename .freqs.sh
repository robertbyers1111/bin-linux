#!/bin/bash
# Script to count frequencies of each word read from stdin (http://stackoverflow.com/questions/10552803/ddg#10552948)
(tr ' ' '\n' | sort | uniq -c | awk '{print "word: "$2" frequency: "$1}')
