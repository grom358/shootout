# fasta
Generate and write random DNA sequences.

Each program should:
* generate DNA sequences, by copying from a given sequence
* generate DNA sequences, by weighted random selection from 2 alphabets
  * convert the expected probability of selecting each nucleotide into cumulative probabilities
  * match a random number against those cumulative probabilities to select each nucleotide (use linear search or binary search)
  * Use this naïve linear congruential generator to calculate a random number each time a nucleotide needs to be selected (don't cache the random number sequence)

    ```
    IM = 139968
    IA = 3877
    IC = 29573
    Seed = 42
        
    Random Number:
    Seed = (Seed * IA + IC) modulo IM
    return float(Seed) / IM
    ```

## Notes
```
# Build
$ ./build.sh

# Clean
$ ./clean.sh

# Generate report
$ ./generate.sh
```

## Results

Tested on AMD Ryzen 5 7600X 6-Core Processor
Windows 11 WSL - Ubuntu 24.04 LTS

Legend:
* Time = Total seconds
* RSS = maximum resident set size in KB

| Language | Time |    RSS |
| -------- | ---: | -----: |
| zig      | 2.18 |    348 |
| go       | 2.25 |   3668 |
| rust     | 2.28 |   2172 |
| odin     | 2.37 |   1792 |
| cpp      | 2.59 |   3732 |
| csharp   | 2.81 |  51704 |
| java     | 2.93 | 368724 |
| c        | 2.96 |   1688 |
