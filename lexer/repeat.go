package main

import (
	"fmt"
	"os"
	"strconv"
)

func main() {
	if len(os.Args) != 4 {
		fmt.Fprintf(os.Stderr, "Usage: %s <repeat> <input-file> <output-file>\n", os.Args[0])
		os.Exit(1)
	}
	strRepeatCount := os.Args[1]
	inputPath := os.Args[2]
	outputPath := os.Args[3]

	repeatCount, err := strconv.Atoi(strRepeatCount)
	if err != nil || repeatCount < 1 {
		fmt.Fprintf(os.Stderr, "Invalid repeat count: %s\n", strRepeatCount)
		os.Exit(1)
	}

	inputData, err := os.ReadFile(inputPath)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error reading input file: %v\n", err)
		os.Exit(1)
	}

	outFile, err := os.Create(outputPath)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error creating output file: %v\n", err)
		os.Exit(1)
	}
	defer outFile.Close()

	for i := 0; i < repeatCount; i++ {
		_, err := outFile.Write(inputData)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error writing to output file: %v\n", err)
			os.Exit(1)
		}
	}
}
