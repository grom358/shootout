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
| c        | 17.11 |  1528 |
| odin     | 17.28 |  1624 |
| cpp      | 17.35 |  3620 |
| go       | 17.45 |  3544 |
| zig      | 17.65 |   264 |
| csharp   | 17.71 | 39004 |
| rust     | 17.99 |  1968 |
| java     | 20.25 | 55324 |
