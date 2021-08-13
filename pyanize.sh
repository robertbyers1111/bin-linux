#!/bin/bash

# Run pyan on all python files found in current directory
#
# TODO: Make this much more flexible from the command line

# Dist opts...
PYANOPTS="--no-defines --uses --colored --annotate --dot -V"

# My variants...
PYANOPTS="--no-defines --uses --colored --dot -V"

echo -ne "Pyan architecture: generating architecture.{dot,svg}\n"
~rmbjr60/iRobot/pyan/pyan.py *.py $PYANOPTS > architecture.dot 2> architecture.log
dot -Tsvg architecture.dot >architecture.svg
[ -f architecture.svg ] && echo Output is architecture.svg
