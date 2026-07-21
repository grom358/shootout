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
## Results

Tested on AMD Ryzen 5 7600X 6-Core Processor
CachyOS 2026.07.06

Legend:
* Time = Total seconds
* RSS = maximum resident set size in KB

| Language | Time |    RSS |
| -------- | ---: | -----: |
| c3       | 2.04 |   5468 |
| c        | 2.09 |   5468 |
| zig      | 2.16 |   5480 |
| go       | 2.21 |   5880 |
| rust     | 2.25 |   5492 |
| odin     | 2.28 |   5540 |
| cpp      | 2.31 |   5496 |
| d        | 2.46 |   5452 |
| nim      | 2.48 |   5464 |
| csharp   | 2.61 |  65164 |
| java     | 2.91 | 130836 |
| ocaml    | 2.96 |   5456 |
