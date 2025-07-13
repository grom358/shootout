#!/bin/bash
if [[ -z "$RAMDISK" ]]; then
  echo "Error: RAMDISK is not set" >&2
  exit 1
fi
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
if [[ ! -s "$RAMDISK/test16000.pbm" ]]; then
  (cd $SCRIPT_DIR/c_reference; ./build.sh)
  echo "Generating mandelbrot/test16000.pbm"
  $SCRIPT_DIR/c_reference/mandelbrot 16000 > $RAMDISK/test16000.pbm
fi
(cd $RAMDISK && md5sum -c $SCRIPT_DIR/test16000.pbm.md5)
