#!/bin/bash
bench() {
  lang=$1
  /usr/bin/time -f "$lang %e %M" $lang/hello 2> time.txt > cmp.txt
  diff test.txt cmp.txt > /dev/null
  ret=$?
  rm cmp.txt
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
