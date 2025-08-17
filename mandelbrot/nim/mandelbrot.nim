import os, strutils, strformat, streams

proc main() =
  if paramCount() != 2:
    echo "Usage: mandelbrot <size> <output.pbm>"
    quit(1)

  let
    N = parseInt(paramStr(1))
    outputPath = paramStr(2)

  var outFile: File
  try:
    outFile = open(outputPath, fmWrite)
  except OSError as e:
    echo "Error creating output: ", e.msg
    quit(1)

  defer: outFile.close()

  let w = N
  let h = N
  let iterations = 50
  let limitSq = 4.0

  var
    bitNum = 0
    byteAcc: byte = 0
    Zr, Zi, Cr, Ci, Tr, Ti: float64

  # write PBM header
  outFile.writeLine("P4")
  outFile.writeLine(fmt"{w} {h}")

  for y in 0..<h:
    Ci = (2.0 * float64(y) / float64(h)) - 1.0
    for x in 0..<w:
      Zr = 0.0
      Zi = 0.0
      Tr = 0.0
      Ti = 0.0
      Cr = (2.0 * float64(x) / float64(w)) - 1.5

      for i in 0..<iterations:
        if Tr + Ti > limitSq:
          break
        Zi = (2.0 * Zr * Zi) + Ci
        Zr = Tr - Ti + Cr
        Tr = Zr * Zr
        Ti = Zi * Zi

      byteAcc = byteAcc shl 1
      if (Tr + Ti) <= limitSq:
        byteAcc = byteAcc or 0x01'u8

      bitNum += 1

      if bitNum == 8:
        discard outFile.writeBytes(@[byteAcc], 0, 1)
        byteAcc = 0
        bitNum = 0
      elif x == w - 1:
        byteAcc = byteAcc shl (8 - (w mod 8))
        discard outFile.writeBytes(@[byteAcc], 0, 1)
        byteAcc = 0
        bitNum = 0

  outFile.flushFile()

when isMainModule:
  main()
