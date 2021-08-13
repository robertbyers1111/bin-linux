#!/bin/bash
# Display current working directory and, if it is detected to be a symlink, displays the physical path as well.
CURRPWD=`pwd`
echo $CURRPWD && [ -L $CURRPWD ] && pwd -P
