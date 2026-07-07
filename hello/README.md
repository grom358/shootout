# Hello
Hello World to test startup and minimum memory costs.

## Shared libraries
* C
  * linux-vdso.so.1
  * /usr/lib/libc.so.6
  * /usr/lib/ld-linux-x86-64.so.2
* C++
  * linux-vdso.so.1
  * /usr/lib/libstdc++.so.6.0.35
  * /usr/lib/libm.so.6
  * /usr/lib/libgcc_s.so.1
  * /usr/lib/libc.so.6
  * /usr/lib/ld-linux-x86-64.so.2
* C#
  * Requires .Net runtime
  * linux-vdso.so.1
  * /usr/lib/libdl.so.2
  * /usr/lib/libpthread.so.0
  * /usr/lib/libstdc++.so.6.0.35
  * /usr/lib/libm.so.6
  * /usr/lib/libgcc_s.so.1
  * /usr/lib/libc.so.6
  * /usr/lib/ld-linux-x86-64.so.2
* C3
  * linux-vdso.so.1
  * /usr/lib/libc.so.6
  * /usr/lib/ld-linux-x86-64.so.2
* D
  * linux-vdso.so.1
  * /usr/lib/libm.so.6
  * /usr/lib/libgcc_s.so.1
  * /usr/lib/libc.so.6
  * /usr/lib/ld-linux-x86-64.so.2
* Go
  * Static binary
* Java
  * Requires JRE
  * linux-vdso.so.1
  * /usr/lib/jvm/java-26-openjdk/lib/libjli.so
  * /usr/lib/libc.so.6
  * /usr/lib/ld-linux-x86-64.so.2
* Nim
  * linux-vdso.so.1
  * /usr/lib/libc.so.6
  * /usr/lib/ld-linux-x86-64.so.2
* Odin
  * linux-vdso.so.1
  * /usr/lib/libm.so.6
  * /usr/lib/libc.so.6
  * /usr/lib/ld-linux-x86-64.so.2
* Rust
  * linux-vdso.so.1
  * /usr/lib/libgcc_s.so.1
  * /usr/lib/libc.so.6
  * /usr/lib/ld-linux-x86-64.so.2
* Zig
  * Static binary

## Results

Tested on AMD Ryzen 5 7600X 6-Core Processor
CachyOS 2026.07.06

Legend:
* Time = Total seconds
* RSS = maximum resident set size in KB
* Size = Binary size in KB (+ Requires runtime)

| Language | Time |   RSS | Size |
| -------- | ---: | ----: | ---: |
| c        | 0.00 |  1428 |   16 |
| cpp      | 0.00 |  3748 |   20 |
| nim      | 0.00 |  1512 |   36 |
| c3       | 0.00 |  1516 |  120 |
| odin     | 0.00 |  1688 |  192 |
| rust     | 0.00 |  2224 |  436 |
| d        | 0.00 |  2868 | 1204 |
| go       | 0.00 |  5676 | 2404 |
| zig      | 0.00 |   684 | 3740 |
| java     | 0.01 | 45940 |   4+ |
| csharp   | 0.01 | 33500 |  80+ |
