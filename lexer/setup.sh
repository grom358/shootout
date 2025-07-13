#!/bin/bash
if [[ -z "$RAMDISK" ]]; then
  echo "Error: RAMDISK is not set" >&2
  exit 1
fi
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
if [[ ! -s "$RAMDISK/test.zs" ]]; then
  for ((i = 0; i <= 20000; i++))
  do
    cat $SCRIPT_DIR/example.zs >> $RAMDISK/test.zs
  done
  (cd $SCRIPT_DIR/go; ./build.sh)
  cat $RAMDISK/test.zs | $SCRIPT_DIR/go/zscript > $RAMDISK/test.csv
fi
