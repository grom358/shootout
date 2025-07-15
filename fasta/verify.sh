#!/bin/bash
source ../lib.sh

EXPECTED=expected1000.txt
ACTUAL=actual1000.txt

for lang in $(cat languages.txt)
do
  bench $lang $EXPECTED $ACTUAL "$lang/fasta 1000 $ACTUAL"
done
