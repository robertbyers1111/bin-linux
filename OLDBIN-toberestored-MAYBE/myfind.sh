#!/bin/bash -x

doit ()
{
  find -L ~ -path '*/vbe*' -prune -o -name $1
}

doit '*ppk'
