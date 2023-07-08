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
| zig      | 1.64 | 292   |
| rust     | 1.94 | 2088  |
| c        | 2.30 | 1468  |
| cpp      | 2.30 | 3876  |
| odin     | 2.38 | 2068  |
| go       | 2.75 | 3468  |
| java     | 3.09 | 39280 |
| csharp   | 3.24 | 31484 |

