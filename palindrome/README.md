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

Tested on AMD Ryzen 5 7600X 6-Core Processor
Windows 11 WSL - Ubuntu 24.04 LTS

Legend:
* Time = Total seconds
* RSS = maximum resident set size in KB

| Language | Time |   RSS |
| -------- | ---: | ----: |
| zig      | 1.43 |   420 |
| rust     | 1.48 |  2336 |
| csharp   | 1.99 | 32072 |
| go       | 2.00 |  3656 |
| odin     | 2.08 |  2252 |
| c        | 2.09 |  1936 |
| cpp      | 2.23 |  4128 |
| java     | 2.27 | 44608 |
