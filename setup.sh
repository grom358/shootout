#!/bin/bash
if [[ -z "$RAMDISK" ]]; then
  echo "Error: RAMDISK is not set"
  exit 1
fi
./fasta/setup.sh
./mandelbrot/setup.sh
./lexer/setup.sh
