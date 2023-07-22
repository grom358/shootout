#!/bin/bash
bench() {
  lang=$1
  cmp=ramdisk/cmp25M.txt
  /usr/bin/time -f "$lang %e %M" $lang/fasta 25000000 2> time.txt > $cmp
  diff test25M.txt $cmp > /dev/null
  ret=$?
  rm $cmp
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
