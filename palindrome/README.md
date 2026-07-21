# Palindrome
Use parallelism to calculate the sum of all numbers with 9 digits that are a 
palindrome.

The answer 49500000000000 should be printed to standard output.

## Notes
* Go implementation uses go routines which are green threads
* All other implementations use physical threads
* Number of cores is hard coded to 4 since many languages didn't have easy way
  to get the number of physical CPU cores, usually providing only virtual cores.

## Results

Tested on AMD Ryzen 5 7600X 6-Core Processor
CachyOS 2026.07.06

Legend:
* Time = Total seconds
* RSS = maximum resident set size in KB

| Language | Time |   RSS |
| -------- | ---: | ----: |
| rust     | 2.03 |  5484 |
| zig      | 2.15 |  5488 |
| c3       | 2.68 |  5428 |
| csharp   | 2.80 | 38488 |
| odin     | 2.83 |  5456 |
| c        | 2.87 |  5500 |
| d        | 3.00 |  5460 |
| cpp      | 3.04 |  5480 |
| go       | 3.09 |  5812 |
| nim      | 3.09 |  5480 |
| ocaml    | 3.11 | 13328 |
| java     | 3.18 | 47544 |
