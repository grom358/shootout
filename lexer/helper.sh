#!/bin/sh
input=$1
prog=$2
output=$3
cat $input | $prog > $output
