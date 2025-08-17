import std/[tables, strutils, sequtils, algorithm, os]

proc countNucleotides(data: string, k: int): CountTable[string] =
  var counts = initCountTable[string]()
  let endIndex = data.len - k
  for i in 0 .. endIndex:
    let fragment = data.substr(i, i + k - 1)
    counts.inc(fragment)
  return counts

proc printFrequencies(outf: File, data: string, k: int) =
  let counts = countNucleotides(data, k)
  var total = 0
  for v in counts.values:
    total += v

  var entries = counts.pairs.toSeq()
  entries.sort(proc (a, b: (string, int)): int =
    result = cmp(b[1], a[1]) # sort descending by value
  )

  for (key, value) in entries:
    let frequency = value.float / total.float
    outf.writeLine(key.toUpperAscii() & " " & formatFloat(frequency * 100, ffDecimal, 3))
  outf.writeLine("")

proc printSampleCount(outf: File, data: string, sample: string) =
  let k = sample.len
  let counts = countNucleotides(data, k)
  let count = counts.getOrDefault(sample.toLowerAscii(), 0)
  outf.writeLine($count & "\t" & sample)

proc main() =
  if paramCount() != 2:
    stderr.writeLine("Usage: knucleotide <input.txt> <output.txt>")
    quit(1)

  let inputFile = paramStr(1)
  let outputFile = paramStr(2)

  var reader = open(inputFile, fmRead)
  defer: reader.close()

  var line: string
  while reader.readLine(line):
    if line.startsWith(">THREE"):
      break

  # Extract DNA sequence THREE
  var sb = newStringOfCap(4096)
  while reader.readLine(line):
    sb.add(line)

  let data = sb

  var outFile = open(outputFile, fmWrite)
  defer: outFile.close()

  printFrequencies(outFile, data, 1)
  printFrequencies(outFile, data, 2)
  printSampleCount(outFile, data, "GGT")
  printSampleCount(outFile, data, "GGTA")
  printSampleCount(outFile, data, "GGTATT")
  printSampleCount(outFile, data, "GGTATTTTAATT")
  printSampleCount(outFile, data, "GGTATTTTAATTTATAGT")

when isMainModule:
  main()
