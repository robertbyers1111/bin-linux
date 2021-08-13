#!/bin/sh
if [ $# -eq 0 ]; then
  tr \[:upper:] \[:lower:]
else
  echo $* | tr \[:upper:] \[:lower:]
fi
