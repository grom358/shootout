package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

var out *bufio.Writer

func main() {
	if len(os.Args) != 3 {
		fmt.Fprintln(os.Stderr, "Usage: fasta [size] [output-file]")
		os.Exit(1)
	}

	N, err := strconv.ParseInt(os.Args[1], 10, 32)
	if err != nil {
		fmt.Fprintln(os.Stderr, "Invalid size argument")
		os.Exit(1)
	}
	n := int(N)

	outputPath := os.Args[2]
	outFile, err := os.Create(outputPath)
	if err != nil {
		fmt.Fprintln(os.Stderr, "Error creating output:", err)
		os.Exit(1)
	}
	defer outFile.Close()

	out = bufio.NewWriter(outFile)
	defer out.Flush()
	alu := []byte(
		"GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTG" +
			"GGAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGA" +
			"GACCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAA" +
			"AATACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAAT" +
			"CCCAGCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAAC" +
			"CCGGGAGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTG" +
			"CACTCCAGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA")
	RepeatFasta(">ONE Homo sapiens alu\n", alu, (2 * n))

	iub := []AminoAcid{
		{0.27, 'a'},
		{0.12, 'c'},
		{0.12, 'g'},
		{0.27, 't'},
		{0.02, 'B'},
		{0.02, 'D'},
		{0.02, 'H'},
		{0.02, 'K'},
		{0.02, 'M'},
		{0.02, 'N'},
		{0.02, 'R'},
		{0.02, 'S'},
		{0.02, 'V'},
		{0.02, 'W'},
		{0.02, 'Y'},
	}
	RandomFasta(">TWO IUB ambiguity codes\n", iub, (3 * n))

	homosapiens := []AminoAcid{
		{0.3029549426680, 'a'},
		{0.1979883004921, 'c'},
		{0.1975473066391, 'g'},
		{0.3015094502008, 't'},
	}
	RandomFasta(">THREE Homo sapiens frequency\n", homosapiens, (5 * n))
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

const (
	IM = 139968
	IA = 3877
	IC = 29573
)

var seed int = 42

func RandomNum() float64 {
	seed = ((seed * IA) + IC) % IM
	return float64(seed) / IM
}

const WIDTH = 60 // Fold lines after WIDTH bytes

// RepeatFasta prints the characters of the byte slice s. When it reaches the
// end of the slice, it goes back to the beginning. It stops after generating
// count characters. After each WIDTH characters it prints a newline. It
// assumes that WIDTH <= len(s) + 1.
func RepeatFasta(header string, s []byte, count int) {
	out.WriteString(header)
	pos := 0
	ss := make([]byte, len(s)+WIDTH)
	copy(ss, s)
	copy(ss[len(s):], s)
	for count > 0 {
		length := min(WIDTH, count)
		out.Write(ss[pos:(pos + length)])
		out.WriteByte('\n')
		pos += length
		if pos > len(s) {
			pos -= len(s)
		}
		count -= length
	}
}

type AminoAcid struct {
	p float64
	c byte
}

func accumulateProbabilities(genelist []AminoAcid) {
	cp := 0.0
	for i := 0; i < len(genelist); i++ {
		cp += genelist[i].p
		genelist[i].p = cp
	}
}

// Each element of genelist is a struct with a character and a floating point
// number p between 0 and 1. RandomFasta generates a random float r and finds
// the first element such that p >= r. This is a weighted random selection.
// RandomFasta then prints the character of the array element. This sequence is
// repeated count times. Between each WIDTH consecutive characters, the
// function prints a newline.
func RandomFasta(header string, genelist []AminoAcid, count int) {
	out.WriteString(header)
	accumulateProbabilities(genelist)
	buf := make([]byte, (WIDTH + 1))
	for count > 0 {
		length := min(WIDTH, count)
		for pos := 0; pos < length; pos++ {
			r := RandomNum()
			for _, amino := range genelist {
				if amino.p >= r {
					buf[pos] = amino.c
					break
				}
			}
		}
		buf[length] = '\n'
		out.Write(buf[0:(length + 1)])
		count -= length
	}
}
