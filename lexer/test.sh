#!/bin/sh
verify() {
  lang=$1
  ./verify.sh $lang/zscript > /dev/null
  if [[ $? -eq 0 ]]
  then
    echo -e "$lang \e[32m[OK]\e[0m"
  else
    echo -e "$lang \e[31m[FAILED]\e[0m"
  fi
}

for lang in $(cat languages.txt)
do
  verify $lang
done
