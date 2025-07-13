#!/bin/bash
for challenge in $(cat challenges.txt)
do
  sed -i '/^## Results/,$d' $challenge/README.md
  cat $challenge/results.txt | ./format_results.sh >> $challenge/README.md
done
