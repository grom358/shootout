#!/bin/sh
for lang in $(cat languages.txt)
do
  (cd $lang; ./clean.sh)
done
