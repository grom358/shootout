#!/bin/bash
bench() {
  lang=$1
  /usr/bin/time -f "$lang %e %M" $lang/mandelbrot 16000 2> time.txt > cmp16000.pbm
  diff test16000.pbm cmp16000.pbm > /dev/null
  ret=$?
  rm cmp16000.pbm
  if [[ $ret -eq 0 ]]
  then
    echo -en "\e[32m[OK]\e[0m "
  else
    echo -en "\e[31m[FAILED]\e[0m "
  fi
  cat time.txt
  rm time.txt
}

for lang in $(cat languages.txt)
do
  bench $lang
done
