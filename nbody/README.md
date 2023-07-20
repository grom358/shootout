# NBody
Model the orbits of Jovian planets, using the same simple symplectic-integrator. From the [The Computer Language Benchmark Games](https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/nbody.html#nbody).

## Results
Tested on Intel(R) Core(TM) i7-7700K CPU @ 4.20GHz

Legend:
* Time = Total seconds
* RSS = maximum resident set size in KB

| Language | Time | RSS   |
| -------- | ---- | ----: |
| cpp      | 2.68 |  3880 |
| zig      | 2.68 |   300 |
| rust     | 2.74 |  1980 |
| c        | 2.84 |  1396 |
| csharp   | 3.75 | 30576 |
| go       | 3.91 |  3416 |
| java     | 4.03 | 43796 |
| odin     | 4.45 |  1780 |
