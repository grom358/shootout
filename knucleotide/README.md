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

Tested on AMD Ryzen 5 7600X 6-Core Processor
Windows 11 WSL - Ubuntu 24.04 LTS

Legend:
* Time = Total seconds
* RSS = maximum resident set size in KB

| Language |  Time |     RSS |
| -------- | ----: | ------: |
| zig      |  6.40 |  487480 |
| go       |  9.86 |  302280 |
| cpp      | 10.35 |  134008 |
| rust     | 13.22 |  138840 |
| c        | 15.74 |  260764 |
| odin     | 16.39 |  141268 |
| nim      | 28.98 |  445180 |
| java     | 30.16 | 1166288 |
| csharp   | 33.10 |  545328 |
| d        | 41.28 |  592844 |
