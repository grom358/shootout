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

| Language | Time  | RSS     |
| -------- | ----- | ------: |
| rust     | 0.79  | 1565188 |
| c        | 0.85  |  782340 |
| cpp      | 0.86  | 1053404 |
| csharp   | 1.08  | 1830572 |
| zig      | 1.47  | 2621268 |
| odin     | 1.48  | 1574440 |
| go       | 1.97  | 6347660 |
| java     | 5.83  | 3329380 |