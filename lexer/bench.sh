#!/bin/sh
prog=$@
cat ramdisk/test.zs | $prog > /dev/null
