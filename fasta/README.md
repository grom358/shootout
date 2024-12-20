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
Tested on Intel(R) Core(TM) i7-7700K CPU @ 4.20GHz

Legend:
* Time = Total seconds
* RSS = maximum resident set size in KB

| Language | Time | RSS    |
| -------- | ---- | -----: |
| zig      | 2.69 |    260 |
| c        | 2.75 |   1528 |
| go       | 2.75 |   3548 |
| rust     | 2.82 |   1816 |
| cpp      | 3.03 |   3804 |
| odin     | 3.24 |   1464 |
| csharp   | 3.72 |  43172 |
| java     | 4.16 | 220960 |
