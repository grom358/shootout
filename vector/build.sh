#!/bin/sh
for lang in $(cat languages.txt)
do
  echo "==Building $lang=="
  (cd $lang; ./build.sh)
done
