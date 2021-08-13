#!/bin/bash
du -hx --max-depth=1 $* | sort -h
