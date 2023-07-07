#!/bin/bash
bench() {
  lang=$1
  /usr/bin/time -f "$lang %e %M" ./bench.sh $lang/zscript 2>&1
}

for lang in $(cat languages.txt)
do
  bench $lang
done
