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
| d        | 0.52 |  785880 |
| rust     | 0.63 | 1565180 |
| cpp      | 0.77 | 1052360 |
| odin     | 1.01 | 1574744 |
| c        | 1.08 |  783288 |
| csharp   | 1.16 | 1798256 |
| nim      | 1.42 | 4824492 |
| zig      | 1.44 | 2454884 |
| java     | 2.73 | 3260228 |
| go       | 3.92 | 6037736 |
