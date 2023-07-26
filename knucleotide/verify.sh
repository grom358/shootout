#!/bin/bash
verify() {
  lang=$1
  /usr/bin/time -f "$lang %e %M" ./helper.sh input1000.txt $lang/knucleotide cmp1000.txt 2> time.txt
  diff test1000.txt cmp1000.txt > /dev/null
  ret=$?
  rm cmp1000.txt
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
