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

The default implementation for languages is to use formatted string output (eg. printf).
Some languages this induces significant overhead and alternative implementations that
bypass this layer are implemented:
* go_custom: Use writer.WriteString calls instead of fmt.Fprintf
* odin_custom: Use string builder instead of fmt.wprintf
* java_custom: Use OutputStream instead of PrintWriter. Note that PrintWriter is using
  synchronzied locks for thread safety.

## Results

Tested on AMD Ryzen 5 7600X 6-Core Processor
CachyOS 2026.07.06

Legend:
* Time = Total seconds
* RSS = maximum resident set size in KB

| Language    | Time |    RSS |
| ----------- | ---: | -----: |
| zig         | 0.29 |  30532 |
| rust        | 0.65 |  31056 |
| go_custom   | 0.69 |  67804 |
| odin_custom | 0.71 |  32572 |
| c           | 0.77 |  51204 |
| nim         | 0.81 |  59816 |
| d_pgo       | 1.01 |  36104 |
| cpp         | 1.02 |  62956 |
| java_custom | 1.04 | 365644 |
| odin        | 1.34 |  32608 |
| csharp      | 1.48 | 165424 |
| go          | 1.51 |  66148 |
| d           | 1.60 |  36116 |
| c3          | 2.25 |  30396 |
| java        | 2.52 | 375384 |
