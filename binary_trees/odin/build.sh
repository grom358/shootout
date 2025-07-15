#!/bin/bash
if [[ "$OS" == "Windows_NT" ]]; then
  EXT=".exe"
else
  EXT=""
fi
odin build . -o:speed -out:binarytree$EXT
