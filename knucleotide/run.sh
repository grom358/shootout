#!/bin/bash
source ../lib.sh
check_ramdisk

INPUT=$RAMDISK/fasta25M.txt
EXPECTED=expected25M.txt
ACTUAL=actual25M.txt

check_file $INPUT

for lang in $(cat languages.txt)
do
  bench $lang $EXPECTED $ACTUAL "$lang/knucleotide $INPUT $ACTUAL"
done
