#!/bin/bash
source ../lib.sh

EXPECTED=expected200.pbm
ACTUAL=actual200.pbm

for lang in $(cat languages.txt)
do
  bench $lang $EXPECTED $ACTUAL "$lang/mandelbrot 200 $ACTUAL"
done
