#!/bin/bash
bench() {
  lang=$1
  /usr/bin/time -f "$lang %e %M" $lang/nbody 50000000 2> time.txt > cmp50000000.txt
  diff test50000000.txt cmp50000000.txt > /dev/null
  ret=$?
  rm cmp50000000.txt
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
