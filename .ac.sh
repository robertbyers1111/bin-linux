#!/bin/bash
USAGE() { echo Usage: `basename $0` [keyword ...]; exit; }
AC_PBGATG0=/home/rmbjr60/MEGA/MEGAsync/314159/AC-PBGATG0-100C.ahk
shopt -s nocasematch
[ $# -eq 0 ] && { gvim $AC_PBGATG0; exit; }
case $1 in -h|-help|--h|--help) USAGE; exit;; esac
while [ $# -gt 0 ]; do grep -iEA12 "$1" $AC_PBGATG0; shift; done
