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
| odin     | 10.82 |  1928 |
| zig      | 11.05 |   348 |
| cpp      | 11.10 |  3764 |
| rust     | 11.60 |  2296 |
| c        | 11.72 |  1824 |
| java     | 11.75 | 51596 |
| go       | 12.22 |  3692 |
| csharp   | 21.38 | 33316 |
