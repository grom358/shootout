#!/bin/bash
source ../lib.sh

EXPECTED=expected10.txt
ACTUAL=actual10.txt

for lang in $(cat languages.txt)
do
  bench $lang $EXPECTED $ACTUAL "$lang/binarytree 10 > $ACTUAL"
done
