#!/bin/bash
check_ramdisk() {
  if [[ -z "$RAMDISK" ]]; then
    echo "Error: RAMDISK is not set" >&2
    exit 1
  fi
}

check_file() {
  file=$1
  if [[ ! -s "$file" ]]; then
    echo "Error: Missing $file" >&2
    exit 1
  fi
}

timer() {
  if command -v /usr/bin/time >/dev/null 2>&1; then
    /usr/bin/time -f "%e %M" bash -c "$@" 2>&1
  else
    start=$(date +%s.%N)
    bash -c "$@"
    end=$(date +%s.%N)
    awk "BEGIN { print $end - $start }"
  fi
}

bench() {
  lang=$1
  expected=$2
  actual=$3
  cmd=$4
  time=$(timer "$cmd")
  diff --strip-trailing-cr $expected $actual > /dev/null
  ret=$?
  rm $actual
  if [[ $ret -eq 0 ]]
  then
    echo -e "\e[32m[OK]\e[0m $lang $time"
  else
    echo -e "\e[31m[FAILED]\e[0m $lang $time"
  fi
}
