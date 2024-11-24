# Palindrome
Use parallelism to calculate the sum of all numbers with 9 digits that are a 
palindrome.

The answer 49500000000000 should be printed to standard output.

## Notes
* Go implementation uses go routines which are green threads
* All other implementations use physical threads
* Number of cores is hard coded to 4 since many languages didn't have easy way
  to get the number of physical CPU cores, usually providing only virtual cores.

```
# Generate report
$ ./generate.sh
```

## Results
Tested on Intel(R) Core(TM) i7-7700K CPU @ 4.20GHz

Legend:
* Time = Total seconds
* RSS = maximum resident set size in KB

| Language | Time | RSS   |
| -------- | ---- | ----: |
| zig      | 1.82 |   264 |
| rust     | 1.96 |  2216 |
| c        | 2.32 |  1500 |
| cpp      | 2.33 |  4024 |
| csharp   | 2.69 | 30176 |
| odin     | 2.84 |  1896 |
| java     | 2.96 | 44324 |
| go       | 3.16 |  5588 |

