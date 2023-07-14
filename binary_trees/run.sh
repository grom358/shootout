#!/bin/bash
bench() {
  lang=$1
  /usr/bin/time -f "$lang %e %M" $lang/binarytree 21 2> err.txt > cmp21.txt
  diff test21.txt cmp21.txt > /dev/null
  ret=$?
  rm cmp21.txt
  if [[ $ret -eq 0 ]]
  then
    echo -en "\e[32m[OK]\e[0m "
  else
    echo -en "\e[31m[FAILED]\e[0m "
  fi
  cat err.txt
  rm err.txt
}

for lang in $(cat languages.txt)
do
  bench $lang
done
