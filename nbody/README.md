# NBody
Model the orbits of Jovian planets, using the same simple symplectic-integrator. From the [The Computer Language Benchmark Games](https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/nbody.html#nbody).

## Results
Tested on Intel(R) Core(TM) i7-7700K CPU @ 4.20GHz

Legend:
* Time = Total seconds
* RSS = maximum resident set size in KB

| Language | Time | RSS   |
| -------- | ---- | ----: |
| zig      | 2.51 |   264 |
| c        | 2.70 |  1512 |
| cpp      | 2.75 |  3812 |
| rust     | 2.86 |  2028 |
| odin     | 3.48 |  1684 |
| csharp   | 3.53 | 38204 |
| go       | 3.84 |  3540 |
| java     | 4.05 | 49492 |
