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
  * linux-vdso.so.1 (0x00007ffce59c2000)
  * libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f2d9f948000)
  * /lib64/ld-linux-x86-64.so.2 (0x00007f2d9fb68000)
* C++
  * linux-vdso.so.1 (0x00007ffe21df3000)
  * libstdc++.so.6 => /lib/x86_64-linux-gnu/libstdc++.so.6 (0x00007f76f4b96000)
  * libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f76f4984000)
  * libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f76f489b000)
  * /lib64/ld-linux-x86-64.so.2 (0x00007f76f4e22000)
  * libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007f76f486d000)
* C#
  * Requires .Net runtime
  * linux-vdso.so.1 (0x00007ffc7adda000)
  * libstdc++.so.6 => /lib/x86_64-linux-gnu/libstdc++.so.6 (0x00007f7145ca8000)
  * libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f7145bbf000)
  * libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007f7145b91000)
  * libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f714597f000)
  * /lib64/ld-linux-x86-64.so.2 (0x00007f7145f45000)
* Go
  * Static binary
* Java
  * Requires JRE
  * linux-vdso.so.1 (0x00007ffd3f7e7000)
  * libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x00007f8f0029f000)
  * libjli.so => not found
  * libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f8f0008d000)
  * /lib64/ld-linux-x86-64.so.2 (0x00007f8f002c9000)
* Odin
  * linux-vdso.so.1 (0x00007fff459d8000)
  * libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f7374dcd000)
  * libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f7374bbb000)
  * /lib64/ld-linux-x86-64.so.2 (0x00007f7374ebf000)
* Rust
  * linux-vdso.so.1 (0x00007ffe7db63000)
  * libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007fab1db69000)
  * libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fab1d957000)
  * /lib64/ld-linux-x86-64.so.2 (0x00007fab1dbf6000)
* Zig
  * Static binary

## Results

Tested on AMD Ryzen 5 7600X 6-Core Processor
Windows 11 WSL - Ubuntu 24.04 LTS

Legend:
* Time = Total seconds
* RSS = maximum resident set size in KB
* Size = Binary size in KB (+ Requires runtime)

| Language | Time |   RSS | Size |
| -------- | ---: | ----: | ---: |
| c        | 0.00 |  1560 |   16 |
| cpp      | 0.00 |  3616 |   16 |
| go       | 0.00 |  3648 | 2164 |
| odin     | 0.00 |  1924 |  160 |
| rust     | 0.00 |  2128 |  416 |
| zig      | 0.00 |   352 |  884 |
| csharp   | 0.02 | 33260 |  80+ |
| java     | 0.02 | 45336 |   4+ |
