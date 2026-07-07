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

## Results

Tested on AMD Ryzen 5 7600X 6-Core Processor
CachyOS 2026.07.06

Legend:
* Time = Total seconds
* RSS = maximum resident set size in KB

| Language |  Time |     RSS |
| -------- | ----: | ------: |
| zig      |  6.99 |  392684 |
| d        |  8.90 |  311660 |
| go       |  9.49 |  376532 |
| cpp      | 10.50 |  133776 |
| rust     | 11.69 |  139088 |
| c        | 14.42 |  259816 |
| odin     | 16.39 |  140952 |
| c3       | 16.69 |  269840 |
| nim      | 20.00 |  446956 |
| java     | 24.48 | 1303032 |
| csharp   | 28.30 |  558408 |
