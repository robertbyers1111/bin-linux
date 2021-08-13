#!/bin/sh

echo ""

while [ $# -gt 0 ]
do
  echo `pwd`/$1 | sed 's#/home/bbyers/#/#' | sed 's#/#\\#g' | sed 's#^#Z:#'
  shift
done


echo ""
echo "            Don't highlight entire line!"
echo "            Use Ctrl-Win-R"
echo ""
