#!/bin/bash
source ../lib.sh

INPUT=input1000.txt
EXPECTED=expected1000.txt
ACTUAL=actual1000.txt

for lang in $(cat languages.txt)
do
  bench $lang $EXPECTED $ACTUAL "$lang/knucleotide $INPUT $ACTUAL"
done
