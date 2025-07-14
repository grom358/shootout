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
| zig      | 1.28 |   348 |
| cpp      | 1.96 |  4004 |
| rust     | 2.10 |  2264 |
| c        | 2.11 |  1780 |
| csharp   | 2.22 | 34420 |
| odin     | 2.38 |  1780 |
| java     | 2.40 | 48908 |
| go       | 2.53 |  3676 |
