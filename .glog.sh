#!/bin/bash

echo
echo % git branch --verbose
echo
echo "  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
git branch --verbose
echo "  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

echo
echo % git log --graph --oneline --all --decorate=short
echo
git log --graph --oneline --all --decorate=short

echo
