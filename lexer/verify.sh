#!/bin/sh
prog=$@

cat example.zs | $prog > cmp.csv
diff --unified example.csv cmp.csv
ret=$?
rm cmp.csv
exit $ret
