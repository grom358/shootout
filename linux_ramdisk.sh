#!/bin/bash
export RAMDISK=/mnt/ramdisk
if [[ ! -d $RAMDISK ]]
then
  echo "Creating ramdisk $RAMDISK"
  mkdir $RAMDISK
  echo "Mounting ramdisk"
  sudo mount -t ramfs -o defaults,user,rw,noatime none $RAMDISK
  USER=$(whoami)
  echo "Setting ramdisk permissions to $USER"
  sudo chown $USER:$USER $RAMDISK
fi
