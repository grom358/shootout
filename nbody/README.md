# NBody
Model the orbits of Jovian planets, using the same simple symplectic-integrator. From the [The Computer Language Benchmark Games](https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/nbody.html#nbody).

## Results

Tested on AMD Ryzen 5 7600X 6-Core Processor
CachyOS 2026.07.06

Legend:
* Time = Total seconds
* RSS = maximum resident set size in KB

| Language | Time |   RSS |
| -------- | ---: | ----: |
| zig      | 1.26 |  5348 |
| c        | 1.92 |  5500 |
| cpp      | 1.92 |  5332 |
| d        | 1.95 |  5480 |
| c3       | 1.99 |  5460 |
| rust     | 2.01 |  5576 |
| nim      | 2.03 |  5496 |
| csharp   | 2.15 | 48468 |
| ocaml    | 2.16 |  5344 |
| odin     | 2.31 |  5500 |
| java     | 2.32 | 49064 |
| go       | 2.49 |  5892 |
