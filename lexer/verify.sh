#!/bin/bash
verify() {
  lang=$1
  /usr/bin/time -f "$lang %e %M" $lang/zscript example.zs cmp.csv 2> time.txt
  diff example.csv cmp.csv > /dev/null
  ret=$?
  rm cmp.csv
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
