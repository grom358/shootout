#!/bin/bash
verify() {
  lang=$1
  /usr/bin/time -f "$lang %e %M" $lang/fasta 1000 2> time.txt > cmp1000.txt
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
