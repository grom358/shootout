# vector
Vector (ie. dynamic resizable array) test.

Each program should:
* Use the naïve linear congruential generator to generate random numbers  
  ```
  IM = 139968
  IA = 3877
  IC = 29573
  Seed = 42
      
  Random Number:
  Seed = (Seed * IA + IC) modulo IM
  return float(Seed) / IM
  ```
* Fill a vector with 200,000,000 random numbers
* Select 1,000 random numbers and print the sum

## Notes
```
# Build
$ ./build.sh

# Clean
$ ./clean.sh

# Generate report
$ ./generate.sh
```

## Results

Tested on AMD Ryzen 5 7600X 6-Core Processor
Windows 11 WSL - Ubuntu 24.04 LTS

Legend:
* Time = Total seconds
* RSS = maximum resident set size in KB

| Language | Time |     RSS |
| -------- | ---: | ------: |
| rust     | 0.63 | 1566540 |
| cpp      | 0.78 | 1052396 |
| odin     | 0.94 | 1574752 |
| csharp   | 1.00 | 1797700 |
| zig      | 1.03 | 2455788 |
| c        | 1.08 |  784512 |
| go       | 2.44 | 5558068 |
| java     | 3.28 | 3260024 |
