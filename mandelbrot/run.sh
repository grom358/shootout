#!/bin/bash
if [[ -z "$RAMDISK" ]]; then
  echo "Error: RAMDISK is not set" >&2
  exit 1
fi
bench() {
  lang=$1
  /usr/bin/time -f "$lang %e %M" $lang/mandelbrot 16000 2> $RAMDISK/time.txt > $RAMDISK/cmp16000.pbm
  diff $RAMDISK/test16000.pbm $RAMDISK/cmp16000.pbm > /dev/null
  ret=$?
  rm $RAMDISK/cmp16000.pbm
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
