#!/bin/sh
if [ $# -eq 0 ]; then
  tr \[:lower:] \[:upper:]
else
  echo $* | tr \[:lower:] \[:upper:]
fi
