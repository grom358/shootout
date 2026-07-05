#!/bin/bash
if [[ -z "$RAMDISK" ]]; then
  echo "Error: RAMDISK is not set"
  exit 1
fi
(cd fasta && ./setup.sh)
(cd mandelbrot && ./setup.sh)
(cd lexer && ./setup.sh)
