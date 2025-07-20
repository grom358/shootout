#!/bin/bash
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
if [ ! -s $SCRIPT_DIR/test.prof ]; then
  source ../../lib.sh
  check_ramdisk

  INPUT=$RAMDISK/test.zs
  EXPECTED=$RAMDISK/test.csv
  ACTUAL=$RAMDISK/cmp.csv

  check_file $INPUT
  check_file $EXPECTED

  ldc2 -O3 -fprofile-generate=rawtest.prof zscript.d

  bench d $EXPECTED $ACTUAL "$SCRIPT_DIR/zscript $INPUT $ACTUAL"

  check_file $SCRIPT_DIR/rawtest.prof

  llvm-profdata-19 merge -output=test.prof rawtest.prof
  rm $SCRIPT_DIR/rawtest.prof

  check_file $SCRIPT_DIR/test.prof
fi

ldc2 -O3 -fprofile-use=test.prof zscript.d
