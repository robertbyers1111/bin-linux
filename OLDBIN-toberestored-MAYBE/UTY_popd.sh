#!/bin/sh
NUM=`dirs | tr ' ' '\n' | uniq | wc -l`
echo NUM:$NUM
