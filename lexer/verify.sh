#!/bin/bash
source ../lib.sh

INPUT=example.zs
EXPECTED=example.csv
ACTUAL=cmp.csv

for lang in $(cat languages.txt)
do
  bench $lang $EXPECTED $ACTUAL "$lang/zscript $INPUT $ACTUAL"
done
