#!/bin/sh
if [[ ! -d ramdisk ]]
then
  mkdir ramdisk
  sudo mount -t ramfs -o defaults,user,rw,noatime none ramdisk
  USER=$(whoami)
  sudo chown $USER:$USER ramdisk
fi
cp ../fasta/test25M.txt ramdisk/input25M.txt
