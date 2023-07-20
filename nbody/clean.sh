#!/bin/sh
for lang in $(cat languages.txt)
do
  echo "==Cleaning $lang=="
  (cd $lang; ./clean.sh)
done
