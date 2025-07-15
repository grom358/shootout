#!/bin/bash
source ../lib.sh
check_ramdisk

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
FILENAME="fasta25M.txt"
EXPECTED="$RAMDISK/$FILENAME"
if [[ ! -s "$EXPECTED" ]]; then
  echo "Generating fasta $EXPECTED"
  (cd $SCRIPT_DIR/go; ./build.sh)
  $SCRIPT_DIR/go/fasta 25000000 $EXPECTED
fi
(cd $RAMDISK && md5sum -c "$SCRIPT_DIR/$FILENAME.md5")
