#!/bin/bash
if [[ -z "$RAMDISK" ]]; then
  echo "Error: RAMDISK is not set" >&2
  exit 1
fi
if [[ ! -s "$RAMDISK/test.zs" ]]; then
  echo "Error: Missing $RAMDISK/test.zs" >&2
  exit 1
fi
if [[ ! -s "$RAMDISK/test.csv" ]]; then
  echo "Error: Missing $RAMDISK/test.csv" >&2
  exit 1
fi
bench() {
  lang=$1
  /usr/bin/time -f "$lang %e %M" ./helper.sh $RAMDISK/test.zs $lang/zscript $RAMDISK/cmp.csv 2> $RAMDISK/time.txt
  diff $RAMDISK/test.csv $RAMDISK/cmp.csv > /dev/null
  ret=$?
  rm $RAMDISK/cmp.csv
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
