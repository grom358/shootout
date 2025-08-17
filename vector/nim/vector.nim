const
  IM  = 139968
  IMF = 139968.0
  IA  = 3877
  IC  = 29573

var seed: int = 42

proc randomNext(max: int): int =
  seed = ((seed * IA) + IC) mod IM
  return int(float64(max) * float64(seed) / IMF)

when isMainModule:
  let max = 100
  let size = 200_000_000
  var numbers = newSeq[int]()   # empty sequence

  # fill the numbers sequence
  for i in 0..<size:
    numbers.add(randomNext(max))

  var sum = 0
  for i in 0..<1000:
    sum += numbers[randomNext(size)]

  echo sum

