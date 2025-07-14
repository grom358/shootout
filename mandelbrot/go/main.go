package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

func main() {
	if len(os.Args) != 3 {
		fmt.Fprintln(os.Stderr, "Usage: mandelbrot <size> <output.pbm>")
		os.Exit(1)
	}

	N, err := strconv.ParseInt(os.Args[1], 10, 32)
	if err != nil {
		fmt.Fprintln(os.Stderr, "Invalid size argument")
		os.Exit(1)
	}

	outputPath := os.Args[2]
	outFile, err := os.Create(outputPath)
	if err != nil {
		fmt.Fprintln(os.Stderr, "Error creating output:", err)
		os.Exit(1)
	}
	defer outFile.Close()


	var bitNum int = 0
	var byteAcc byte = 0
	iterations := 50
	limitSq := 4.0
	var Zr, Zi, Cr, Ci, Tr, Ti float64

	var w int = int(N)
	var h int = int(N)

	writer := bufio.NewWriterSize(outFile, 4096)
	fmt.Fprintf(writer, "P4\n%d %d\n", w, h)

	for y := 0; y < h; y++ {
		Ci = ((2.0 * float64(y)) / float64(h)) - 1.0
		for x := 0; x < w; x++ {
			Zr, Zi, Tr, Ti = 0.0, 0.0, 0.0, 0.0
			Cr = ((2.0 * float64(x)) / float64(w)) - 1.5

			for i := 0; (i < iterations) && ((Tr + Ti) <= limitSq); i++ {
				Zi = (2.0 * Zr * Zi) + Ci
				Zr = Tr - Ti + Cr
				Tr = Zr * Zr
				Ti = Zi * Zi
			}

			byteAcc <<= 1
			if (Tr + Ti) <= limitSq {
				byteAcc |= 0x01
			}

			bitNum++

			if bitNum == 8 {
				writer.WriteByte(byteAcc)
				byteAcc = 0
				bitNum = 0
			} else if x == (w - 1) {
				byteAcc <<= (8 - (w % 8))
				writer.WriteByte(byteAcc)
				byteAcc = 0
				bitNum = 0
			}
		}
	}
	writer.Flush()
}
