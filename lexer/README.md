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

# Benchmark all implementations and generate report
$ ./generate.sh
```

The following implementations are slow with built-in output formatting:
* Go
* Java (PrintWriter also uses synchroized locks)
* Odin

Legend:
* Format = Using built-in output formatting
* Custom = Custom output

| Language | Format | Custom |
| -------- | -----: | -----: |
| Go       | 3.312  | 1.240  |
| Java     | 5.735  | 2.471  |
| Odin     | 5.935  | 2.322  |

## Results

Tested on AMD Ryzen 5 7600X 6-Core Processor
Windows 11 WSL - Ubuntu 24.04 LTS

Legend:
* Time = Total seconds
* RSS = maximum resident set size in KB

| Language | Time |    RSS |
| -------- | ---: | -----: |
| zig      | 0.60 |  93560 |
| odin     | 0.70 |  34840 |
| rust     | 0.74 |  30708 |
| go       | 0.75 |  62380 |
| c        | 0.96 |  51396 |
| cpp      | 1.10 |  61440 |
| d_pgo    | 1.11 |  36204 |
| csharp   | 1.24 | 166148 |
| nim      | 1.33 |  59340 |
| java     | 1.42 | 578408 |
| d        | 1.75 |  36676 |
