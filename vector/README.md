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

## Results

Tested on AMD Ryzen 5 7600X 6-Core Processor
CachyOS 2026.07.06

Legend:
* Time = Total seconds
* RSS = maximum resident set size in KB

| Language | Time |     RSS |
| -------- | ---: | ------: |
| d        | 0.49 |  786772 |
| zig      | 0.52 | 1565860 |
| rust     | 0.55 | 1565884 |
| cpp      | 0.57 | 1053340 |
| c        | 0.77 |  784144 |
| odin     | 0.81 | 1564608 |
| c3       | 0.89 | 1050300 |
| csharp   | 0.91 | 1841380 |
| go       | 0.99 | 4843988 |
| nim      | 1.06 | 4513516 |
| java     | 1.21 | 1809712 |
