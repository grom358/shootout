#!/bin/sh
nim c -d:release --opt:speed \
  --passC:"-O3 -march=native -flto" \
  --passL:"-O3 -march=native -flto" -d:strip hello.nim
