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
Tested on Intel(R) Core(TM) i7-7700K CPU @ 4.20GHz

Legend:
* Time = Total seconds
* RSS = maximum resident set size in KB

| Language | Time | RSS     |
| -------- | ---- | ------: |
| rust     | 0.73 | 1564628 |
| c        | 0.83 |  783992 |
| cpp      | 0.86 | 1053988 |
| odin     | 0.90 | 1574664 |
| csharp   | 1.10 | 1829820 |
| zig      | 1.25 | 2454372 |
| go       | 3.17 | 6257164 |
| java     | 4.88 | 3183480 |
