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
| zig      |  6.86 |  487524 |
| go       |  9.83 |  392024 |
| cpp      | 10.54 |  133568 |
| rust     | 12.22 |  137804 |
| c        | 16.10 |  261568 |
| odin     | 16.40 |  140904 |
| java     | 28.65 | 1005208 |
| csharp   | 33.45 |  547204 |
