#!/bin/sh
gcc -O3 -Werror -Wall -pedantic -std=c17 -o knucleotide knucleotide.c file_readall.c
