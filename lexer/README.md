# Lexer
A lexer for the scripting language defined in example.zs

Implementations are required to accept input from standard input and output CSV in the format:

```
line_no,col_no,"token_text","token_type"
```

Where token types are:
* illegal (any invalid character)
* eof (end of file)
* whitespace [ \t\r\n]+
* comment (# upto and including \n)
* ; : , ( ) [ ] { }
* ^ + - * / % ~ = < >
* += -= *= /= %= ~= == <= >= !=
* "string"
* integer [0-9][0-9_]+
* float [0-9][0-9]+.[0-9_]+[eE][+-]?[0-9_]+
* id [a-zA-Z_][a-zA-Z_0-9]+
* keywords:
  * let
  * true
  * false
  * and
  * or
  * xor
  * not
  * if
  * else
  * while
  * foreach
  * as
  * function
  * return

For strings the surrounding double quotes are stripped in the CSV.

## Notes
To avoid I/O bottleneck dominating the benchmark the input is put into RAM (see setup.sh)

```
# Build
$ ./build.sh

# Clean build artifacts
$ ./clean.sh

# verify individual implementation
$ ./verify.sh path/to/zscript

# verify all implementations
$ ./test.sh

# Setup benchmarking by first creating test.zs on ramdisk
$ sudo ./setup.sh

# Benchmark an implementation
$ time ./bench.sh path/to/zscript # eg. time ./bench go/zscipt

# Benchmark all implemenations and generate report
$ ./report.sh | sort -n -k2 | tee results.txt
```
