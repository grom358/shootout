#!/bin/bash
source ../lib.sh

EXPECTED=expected.txt
ACTUAL=actual.txt

for lang in $(cat languages.txt)
do
  bench $lang $EXPECTED $ACTUAL "$lang/palindrome > $ACTUAL"
done
