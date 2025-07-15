#!/bin/bash
source ../lib.sh
check_ramdisk

EXPECTED="mandelbrot_expected16000.pbm"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
if [[ ! -s "$RAMDISK/$EXPECTED" ]]; then
  (cd $SCRIPT_DIR/c_reference; ./build.sh)
  echo "Generating mandelbrot/$EXPECTED"
  $SCRIPT_DIR/c_reference/mandelbrot 16000 $RAMDISK/$EXPECTED
fi
(cd $RAMDISK && md5sum -c $SCRIPT_DIR/expected16000.pbm.md5)
