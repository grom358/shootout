#!/bin/bash
if [[ -z "$RAMDISK" ]]; then
  echo "Error: RAMDISK is not set" >&2
  exit 1
fi
if [[ ! -s "$RAMDISK" ]]; then
  echo "Error: Missing $RAMDISK/test25M.txt" >&2
  exit 1
fi
bench() {
  lang=$1
  /usr/bin/time -f "$lang %e %M" $lang/fasta 25000000 2> $RAMDISK/time.txt > $RAMDISK/cmp25M.txt
  diff $RAMDISK/test25M.txt $RAMDISK/cmp25M.txt > /dev/null
  ret=$?
  rm $RAMDISK/cmp25M.txt
  if [[ $ret -eq 0 ]]
  then
    echo -en "\e[32m[OK]\e[0m "
  else
    echo -en "\e[31m[FAILED]\e[0m "
  fi
  cat $RAMDISK/time.txt
  rm $RAMDISK/time.txt
}

for lang in $(cat languages.txt)
do
  bench $lang
done
