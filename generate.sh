#!/bin/bash
for challenge in $(cat challenges.txt);
do
    echo "### $challenge ###"
    (cd $challenge && ./generate.sh)
done
