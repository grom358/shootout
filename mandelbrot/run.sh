#!/bin/bash
source ../lib.sh
check_ramdisk

EXPECTED=$RAMDISK/mandelbrot_expected16000.pbm
ACTUAL=$RAMDISK/mandelbrot_actual16000.pbm

check_file $EXPECTED

for lang in $(cat languages.txt)
do
  bench $lang $EXPECTED $ACTUAL "$lang/mandelbrot 16000 $ACTUAL"
done
