#!/bin/bash
source ../lib.sh

INPUT=1000
EXPECTED=expected1000.txt
ACTUAL=actual1000.txt

for lang in $(cat languages.txt)
do
  bench $lang $EXPECTED $ACTUAL "$lang/nbody $INPUT > $ACTUAL"
done
