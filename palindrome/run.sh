#!/bin/sh
verify() {
  lang=$1
  result=$(/usr/bin/time -f "$lang %e %M" $lang/palindrome 2> err.txt)
  if [[ "$result" = "49500000000000" ]]
  then
    echo -en "\e[32m[OK]\e[0m "
  else
    echo -en "\e[31m[FAILED]\e[0m "
  fi
  cat err.txt
}

for lang in $(cat languages.txt)
do
  verify $lang
done
rm err.txt
