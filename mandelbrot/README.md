# Mandelbrot
Plot the Mandelbrot set [-1.5-i,0.5+i] on an 16000x16000 bitmap. Write output in portable bitmap format (pbm).

## Notes
c_reference contains the reference implementation. Used to generate test16000.pbm for comparison.

## Results

Tested on AMD Ryzen 5 7600X 6-Core Processor
CachyOS 2026.07.06

Legend:
* Time = Total seconds
* RSS = maximum resident set size in KB

| Language |  Time |   RSS |
| -------- | ----: | ----: |
| c3       | 10.20 |  5512 |
| zig      | 10.57 |  5468 |
| odin     | 10.67 |  5460 |
| nim      | 10.70 |  5460 |
| rust     | 10.87 |  5508 |
| cpp      | 11.05 |  5440 |
| java     | 11.06 | 49600 |
| c        | 11.13 |  5480 |
| go       | 11.61 |  5896 |
| ocaml    | 11.92 |  5440 |
| d        | 12.87 |  5444 |
| csharp   | 23.37 | 50176 |
