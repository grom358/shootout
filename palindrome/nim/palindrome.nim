import std/threadpool
{.experimental: "parallel".}

proc isPalindrome(n: int): bool =
  var
    reversed = 0
    original = n
    m = n
  while m != 0:
    let digit = m mod 10
    reversed = reversed * 10 + digit
    m = m div 10
  result = (original == reversed)

proc calcSum(s: int, e: int): int64 =
  var subtotal = 0
  for x in s .. e:
    if isPalindrome(x):
      subtotal += x
  return subtotal

when isMainModule:
  let start = 100_000_000
  let finish = 999_999_999
  let range = finish - start

  let cores = 4
  let chunk = range div cores

  var results = newSeq[int64](cores)
  parallel for i in 0..<results.len:
    let s = start + chunk * i
    let e = if i == cores - 1: finish else: s + chunk - 1
    results[i] = spawn calcSum(s, e)

  var total: int64 = 0
  for r in results:
    total += r

  echo total

