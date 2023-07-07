#!/bin/sh
./report.sh | tee /dev/tty | sort -n -k2 > results.txt; echo "====="; cat results.txt
