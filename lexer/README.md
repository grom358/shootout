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
CachyOS 2026.07.06

Legend:
* Time = Total seconds
* RSS = maximum resident set size in KB

| Language | Time |    RSS |
| -------- | ---: | -----: |
| zig      | 0.49 |  30688 |
| go       | 0.76 |  65668 |
| odin     | 0.77 |  32500 |
| rust     | 0.80 |  31056 |
| c        | 0.84 |  51124 |
| nim      | 0.87 |  59396 |
| d_pgo    | 1.08 |  36092 |
| cpp      | 1.14 |  62236 |
| java     | 1.17 | 365700 |
| csharp   | 1.54 | 168328 |
| d        | 1.69 |  36108 |
| c3       | 2.37 |  30392 |
