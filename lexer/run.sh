#!/bin/bash
source ../lib.sh
check_ramdisk

INPUT=$RAMDISK/test.zs
EXPECTED=$RAMDISK/test.csv
ACTUAL=$RAMDISK/cmp.csv

check_file $INPUT
check_file $EXPECTED

for lang in $(cat languages.txt)
do
  bench $lang $EXPECTED $ACTUAL "$lang/zscript $INPUT $ACTUAL"
done
