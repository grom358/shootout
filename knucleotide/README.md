# knucleotide
Hashtable of k-nucleotide strings.

Each program should:
 * read line-by-line a redirected FASTA format file from stdin
 * extract DNA sequence THREE
 * define a procedure/function to update a hashtable of k-nucleotide keys and
   count values, for a particular reading-frame — even though we'll combine
   k-nucleotide counts for all reading-frames (grow the hashtable from a small
   default size)
 * use that procedure/function and hashtable to
   * count all the 1-nucleotide and 2-nucleotide sequences, and write the code
     and percentage frequency, sorted by descending frequency and then ascending
     k-nucleotide key
   * count all the 3- 4- 6- 12- and 18-nucleotide sequences, and write the count
    and code for the specific sequences GGT GGTA GGTATT GGTATTTTAATT GGTATTTTAATTTATAGT

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

| Language | Time  | RSS    |
| -------- | ----- | -----: |
| zig      | 11.42 | 373192 |
| rust     | 20.88 | 137716 |
| go       | 23.18 | 302052 |
| c        | 25.32 | 260300 |
| cpp      | 28.16 | 134400 |
| java     | 45.64 | 772428 |
| csharp   | 55.79 | 541768 |
| odin     | 57.81 | 142704 |
