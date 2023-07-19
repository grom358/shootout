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
Tested on Intel(R) Core(TM) i7-7700K CPU @ 4.20GHz

Legend:
* Time = Total seconds
* RSS = maximum resident set size in KB

| Language | Time  | RSS   |
| -------- | ----- | ----: |
| c        | 16.99 |  1296 |
| odin     | 17.41 |  1752 |
| cpp      | 17.42 |  3732 |
| csharp   | 17.62 | 32580 |
| go       | 17.78 |  3424 |
| zig      | 17.92 |   300 |
| rust     | 18.03 |  1716 |
| java     | 19.72 | 46280 | 
