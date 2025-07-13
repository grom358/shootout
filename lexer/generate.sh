#!/bin/sh
./run.sh | tee /dev/tty | sort -n -k3 > results.txt; echo "====="; cat results.txt
