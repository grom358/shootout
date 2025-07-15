#!/bin/bash
source ../lib.sh

INPUT=50000000
EXPECTED=expected50M.txt
ACTUAL=actual50M.txt

for lang in $(cat languages.txt)
do
  bench $lang $EXPECTED $ACTUAL "$lang/nbody $INPUT > $ACTUAL"
done
