#!/bin/bash
[ -r "$1" ] && gzip -l "$1" | commify || echo ERROR: $1 not exist, or is not a file, or is not readable
