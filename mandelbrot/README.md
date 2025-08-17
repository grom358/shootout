# Mandelbrot
Plot the Mandelbrot set [-1.5-i,0.5+i] on an 16000x16000 bitmap. Write output in portable bitmap format (pbm).

## Notes
c_reference contains the reference implementation. Used to generate test16000.pbm for comparison.

```
# Create test dataset.
$ ./setup.sh

# Generate report
$ ./generate.sh
```

## Results

Tested on AMD Ryzen 5 7600X 6-Core Processor
Windows 11 WSL - Ubuntu 24.04 LTS

Legend:
* Time = Total seconds
* RSS = maximum resident set size in KB

| Language |  Time |   RSS |
| -------- | ----: | ----: |
| nim      |  9.87 |  3412 |
| odin     | 10.46 |  3320 |
| zig      | 10.52 |  3400 |
| d        | 11.07 |  4124 |
| go       | 11.26 |  3676 |
| rust     | 11.92 |  3460 |
| java     | 12.10 | 51528 |
| cpp      | 12.24 |  3768 |
| c        | 13.78 |  3412 |
| csharp   | 22.83 | 31380 |
