#!/bin/bash
FUNCS_TXT=~/public_html/sh/functions.txt
[ -f $FUNCS_TXT ] && cat $FUNCS_TXT || echo NOT EXIST: $FUNCS_TXT
