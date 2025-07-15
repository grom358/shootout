#!/bin/bash
source ../lib.sh

EXPECTED=expected21.txt
ACTUAL=actual21.txt

for lang in $(cat languages.txt)
do
  bench $lang $EXPECTED $ACTUAL "$lang/binarytree 21 > $ACTUAL"
done
