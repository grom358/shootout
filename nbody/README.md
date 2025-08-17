# NBody
Model the orbits of Jovian planets, using the same simple symplectic-integrator. From the [The Computer Language Benchmark Games](https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/nbody.html#nbody).

## Results

Tested on AMD Ryzen 5 7600X 6-Core Processor
Windows 11 WSL - Ubuntu 24.04 LTS

Legend:
* Time = Total seconds
* RSS = maximum resident set size in KB

| Language | Time |   RSS |
| -------- | ---: | ----: |
| zig      | 1.29 |  3404 |
| cpp      | 1.90 |  4100 |
| d        | 1.91 |  3436 |
| rust     | 2.01 |  3344 |
| c        | 2.04 |  3448 |
| csharp   | 2.13 | 32216 |
| java     | 2.31 | 49220 |
| go       | 2.45 |  3668 |
| odin     | 2.47 |  3416 |
| nim      | 3.25 |  3480 |
