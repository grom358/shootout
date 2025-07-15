#!/bin/bash
source ../lib.sh
check_ramdisk

EXPECTED=$RAMDISK/fasta25M.txt
ACTUAL=$RAMDISK/fasta_actual25M.txt

check_file $EXPECTED

for lang in $(cat languages.txt)
do
  bench $lang $EXPECTED $ACTUAL "$lang/fasta 25000000 $ACTUAL"
done
