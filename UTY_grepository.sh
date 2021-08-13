#!/bin/bash
echo
echo basename \`git rev-parse --show-toplevel\`
echo
echo -n "           repository: " ; basename `git rev-parse --show-toplevel`
echo    "               branch: `git branch`"
echo    "    working directory: `pwd`"
echo
