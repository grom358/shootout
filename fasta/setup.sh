#!/bin/sh
if [[ ! -d ramdisk ]]
then
  mkdir ramdisk
  sudo mount -t ramfs -o defaults,user,rw,noatime none ramdisk
  USER=$(whoami)
  sudo chown $USER:$USER ramdisk
fi
(cd go; ./build.sh)
go/fasta 25000000 > test25M.txt
