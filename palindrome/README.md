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
| rust     | 1.48 |  3472 |
| zig      | 1.54 |  3384 |
| go       | 1.92 |  3664 |
| csharp   | 1.96 | 34060 |
| c        | 1.97 |  3332 |
| odin     | 2.03 |  3452 |
| cpp      | 2.04 |  4208 |
| d        | 2.21 |  3300 |
| java     | 2.32 | 45044 |
| nim      | 2.58 |  3500 |
