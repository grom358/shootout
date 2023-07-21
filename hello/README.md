# Hello
Hello World to test startup and minimum memory costs.

## Notes
```
# Build
$ ./build.sh

# Clean
$ ./clean.sh

# Generate report
$ ./generate.sh
```

## Shared libraries
* C
  * linux-vdso.so.1 (0x00007ffddab85000)
  * libc.so.6 => /usr/lib/libc.so.6 (0x00007f8e69e29000)
  * /lib64/ld-linux-x86-64.so.2 => /usr/lib64/ld-linux-x86-64.so.2 (0x00007f8e6a045000)
* C++
  * linux-vdso.so.1 (0x00007ffd61b9a000)
  * libstdc++.so.6 => /usr/lib/libstdc++.so.6   * (0x00007fd817c00000)
  * libm.so.6 => /usr/lib/libm.so.6   * (0x00007fd817b13000)
  * libgcc_s.so.1 => /usr/lib/libgcc_s.so.1   * (0x00007fd817ea1000)
  * libc.so.6 => /usr/lib/libc.so.6   * (0x00007fd817929000)
  * /lib64/ld-linux-x86-64.so.2 => /usr/lib64/ld-linux-x86-64.so.2 (0x00007fd817ef8000)
* C#
  * Requires .Net runtime
  * linux-vdso.so.1 (0x00007ffce8374000)
  * libstdc++.so.6 => /usr/lib/libstdc++.so.6   * (0x00007f540c400000)
  * libm.so.6 => /usr/lib/libm.so.6   * (0x00007f540c748000)
  * libgcc_s.so.1 => /usr/lib/libgcc_s.so.1   * (0x00007f540c723000)
  * libc.so.6 => /usr/lib/libc.so.6   * (0x00007f540c216000)
  * /lib64/ld-linux-x86-64.so.2 => /usr/lib64/ld-linux-x86-64.so.2 (0x00007f540c876000)
* Go
  * Static binary
* Java
  * Requires JRE
  * linux-vdso.so.1 (0x00007ffe2197c000)
  * libjli.so => not found
  * libc.so.6 => /usr/bin/../lib/libc.so.6   * (0x00007f6804ed8000)
  * /lib64/ld-linux-x86-64.so.2 => /usr/lib64/ld-linux-x86-64.so.2 (0x00007f68050f4000)
* Odin
  * linux-vdso.so.1 (0x00007ffd8bd18000)
  * libc.so.6 => /usr/lib/libc.so.6   * (0x00007f894a503000)
  * libm.so.6 => /usr/lib/libm.so.6   * (0x00007f894a416000)
  * /lib64/ld-linux-x86-64.so.2 => /usr/lib64/ld-linux-x86-64.so.2 (0x00007f894a71a000)
* Rust
  * linux-vdso.so.1 (0x00007fe393a4e000)
  * libgcc_s.so.1 => /usr/lib/libgcc_s.so.1   * (0x00007fe3939a9000)
  * libc.so.6 => /usr/lib/libc.so.6   * (0x00007fe3937bf000)
  * /lib64/ld-linux-x86-64.so.2 => /usr/lib64/  * ld-linux-x86-64.so.2 (0x00007fe393a50000)
* Zig
  * Static binary

## Results
Tested on Intel(R) Core(TM) i7-7700K CPU @ 4.20GHz

Legend:
* Time = Total seconds
* RSS = maximum resident set size in KB
* Bin = Binary size in KB (+ Requires runtime)

| Language | Time | RSS   | Size |
| -------- | ---- | ----: | ---: |
| zig      | 0.00 |   300 |  701 |
| c        | 0.00 |  1296 |   15 |
| odin     | 0.00 |  1724 |  213 |
| rust     | 0.00 |  1940 | 4284 |
| cpp      | 0.00 |  3684 |   16 |
| go       | 0.00 |  3364 | 1848 |
| csharp   | 0.05 | 31784 | 641+ |
| java     | 0.05 | 37828 |   3+ |