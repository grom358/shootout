#!/bin/sh
if [[ ! -d ramdisk ]]
then
  mkdir ramdisk
  sudo mount -t ramfs -o defaults,user,rw,noatime none ramdisk
  USER=$(whoami)
  sudo chown $USER:$USER ramdisk
fi
for ((i = 0; i <= 20000; i++))
do
  cat example.zs >> ramdisk/test.zs
done
