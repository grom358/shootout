#!/bin/bash
if [[ -z "$RAMDISK" ]]; then
  echo "Error: RAMDISK is not set" >&2
  exit 1
fi
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
if [[ ! -s "$RAMDISK/test.zs" ]]; then
  go run repeat.go 20000 $SCRIPT_DIR/example.zs $RAMDISK/test.zs
  (cd $SCRIPT_DIR/go; ./build.sh)
  $SCRIPT_DIR/go/zscript $RAMDISk/test.zs $RAMDISK/test.csv
fi
