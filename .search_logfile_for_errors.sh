#!/bin/bash

cat "$1" \
 | col -bx \
 | grep -Eiv "^  *-w error |help.*locale.*cannot find document:|locale is free of encoding errors|^/mtkoss/gcc/.*/bin/g++.*errors.*errors.*errors.*errors| errors\.o " \
 | gvim -geometry=184x45+4+118 -s ~/bin/searchfor_ERROR.vim -
