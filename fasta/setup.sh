#!/bin/bash
if [[ -z "$RAMDISK" ]]; then
  echo "Error: RAMDISK is not set" >&2
  exit 1
fi
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
if [[ ! -s "$RAMDISK/test25M.txt" ]]; then
  echo "Generating fasta test25M.txt"
  (cd $SCRIPT_DIR/go; ./build.sh)
  $SCRIPT_DIR/go/fasta 25000000 $RAMDISK/test25M.txt
fi
(cd $RAMDISK && md5sum -c $SCRIPT_DIR/test25M.txt.md5)
