import os, strutils

const
  IM    = 139_968
  IA    = 3_877
  IC    = 29_573
  WIDTH = 60

var seed = 42

type
  AminoAcid = object
    p*: float
    c*: char

proc randomNum(): float =
  seed = (seed * IA + IC) mod IM
  result = seed.float / IM.float

proc repeatFasta(file: var File, header, s: string, count: int) =
  file.write(header)
  var pos = 0
  let sLen = s.len
  let ss = s & s
  var remaining = count
  while remaining > 0:
    let length = min(WIDTH, remaining)
    # slice is half-open on the right
    file.write(ss[pos ..< pos + length])
    file.write('\n')
    pos += length
    if pos > sLen:
      pos -= sLen
    remaining -= length

proc accumulateProbabilities(genelist: var openArray[AminoAcid]) =
  var cp = 0.0
  for i in 0 ..< genelist.len:
    cp += genelist[i].p
    genelist[i].p = cp

proc randomFasta(file: var File, header: string,
                  genelistIn: var openArray[AminoAcid],
                  count: int) =
  file.write(header)
  accumulateProbabilities(genelistIn)
  var remaining = count
  while remaining > 0:
    let length = min(WIDTH, remaining)
    var buf = newString(length)
    for pos in 0 ..< length:
      let r = randomNum()
      for i in 0 ..< genelistIn.len:
        if genelistIn[i].p >= r:
          buf[pos] = genelistIn[i].c
          break
    file.write(buf)
    file.write('\n')
    remaining -= length

proc main() =
  if paramCount() != 2:
    stderr.writeLine("Usage: fasta <size> <output.txt>")
    quit(1)

  let n = parseInt(paramStr(1))
  var f: File
  if not open(f, paramStr(2), fmWrite):
    stderr.writeLine("Unable to open file '" & paramStr(2) & "': " &
                     osErrorMsg(osLastError()))
    quit(1)
  defer: close(f)

  let alu = "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTG" &
            "GGAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGA" &
            "GACCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAA" &
            "AATACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAAT" &
            "CCCAGCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAAC" &
            "CCGGGAGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTG" &
            "CACTCCAGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA"

  repeatFasta(f, ">ONE Homo sapiens alu\n", alu, 2 * n)

  var iub = [
    AminoAcid(p: 0.27, c: 'a'), AminoAcid(p: 0.12, c: 'c'),
    AminoAcid(p: 0.12, c: 'g'), AminoAcid(p: 0.27, c: 't'),
    AminoAcid(p: 0.02, c: 'B'), AminoAcid(p: 0.02, c: 'D'),
    AminoAcid(p: 0.02, c: 'H'), AminoAcid(p: 0.02, c: 'K'),
    AminoAcid(p: 0.02, c: 'M'), AminoAcid(p: 0.02, c: 'N'),
    AminoAcid(p: 0.02, c: 'R'), AminoAcid(p: 0.02, c: 'S'),
    AminoAcid(p: 0.02, c: 'V'), AminoAcid(p: 0.02, c: 'W'),
    AminoAcid(p: 0.02, c: 'Y')
  ]
  randomFasta(f, ">TWO IUB ambiguity codes\n", iub, 3 * n)

  var homosapiens = [
    AminoAcid(p: 0.3029549426680, c: 'a'),
    AminoAcid(p: 0.1979883004921, c: 'c'),
    AminoAcid(p: 0.1975473066391, c: 'g'),
    AminoAcid(p: 0.3015094502008, c: 't')
  ]
  randomFasta(f, ">THREE Homo sapiens frequency\n", homosapiens, 5 * n)

when isMainModule:
  main()

