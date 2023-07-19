#!/bin/bash
verify() {
  lang=$1
  /usr/bin/time -f "$lang %e %M" $lang/mandelbrot 200 2> time.txt > cmp200.pbm
  diff test200.pbm cmp200.pbm > /dev/null
  ret=$?
  rm cmp200.pbm
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
  verify $lang
done
