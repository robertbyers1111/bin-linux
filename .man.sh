#!/bin/bash
[ $# -lt 1 ] && { echo USAGE: `basename $0` pattern.. ; exit; }
man $* | col -bx | gvim -R - | grep -v "Vim: Reading from stdin"
