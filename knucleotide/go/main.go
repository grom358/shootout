package main

import (
	"bufio"
	"fmt"
	"os"
	"sort"
	"strings"
)

func countNucleotides(data string, k int) map[string]int {
	counts := make(map[string]int)
	endIndex := len(data) - k
	for i := 0; i <= endIndex; i++ {
		fragment := data[i : i+k]
		counts[fragment]++
	}
	return counts
}

type Pair struct {
	Key   string
	Value int
}

type PairList []Pair

func (p PairList) Len() int		   { return len(p) }
func (p PairList) Less(i, j int) bool { return p[i].Value > p[j].Value }
func (p PairList) Swap(i, j int)	  { p[i], p[j] = p[j], p[i] }

func sortMapByValue(counts map[string]int) PairList {
	pairs := make(PairList, len(counts))
	i := 0
	for k, v := range counts {
		pairs[i] = Pair{k, v}
		i++
	}
	sort.Sort(pairs)
	return pairs
}

func printFrequencies(writer *bufio.Writer, data string, k int) {
	counts := countNucleotides(data, k)
	total := 0
	for _, value := range counts {
		total += value
	}

	sortedEntries := sortMapByValue(counts)

	for _, entry := range sortedEntries {
		frequency := float64(entry.Value) / float64(total) * 100.0
		fmt.Fprintf(writer, "%s %.3f\n", strings.ToUpper(entry.Key), frequency)
	}
	fmt.Fprintln(writer)
}

func printSampleCount(writer *bufio.Writer, data string, sample string) {
	k := len(sample)
	counts := countNucleotides(data, k)
	sampleLower := strings.ToLower(sample)
	count, found := counts[sampleLower]
	if !found {
		count = 0
	}
	fmt.Fprintf(writer, "%d\t%s\n", count, sample)
}

func main() {
	if len(os.Args) != 3 {
		fmt.Fprintln(os.Stderr, "Usage: knucleotide [input-file] [output-file]")
		os.Exit(1)
	}

	inputPath := os.Args[1]
	outputPath := os.Args[2]

	inFile, err := os.Open(inputPath)
	if err != nil {
		fmt.Fprintln(os.Stderr, "Error opening input:", err)
		os.Exit(1)
	}
	defer inFile.Close()
	reader := bufio.NewReader(inFile)
	var line string
	for {
		line, _ = reader.ReadString('\n')
		if strings.HasPrefix(line, ">THREE") {
			break
		}
	}

	// Extract DNA sequence THREE.
	var lines strings.Builder
	for {
		line, err := reader.ReadString('\n')
		if err != nil {
			break
		}
		lines.WriteString(strings.Trim(line, "\r\n"))
	}
	data := lines.String()

	outFile, err := os.Create(outputPath)
	if err != nil {
		fmt.Fprintln(os.Stderr, "Error creating output:", err)
		os.Exit(1)
	}
	defer outFile.Close()

	writer := bufio.NewWriterSize(outFile, 4096)
	printFrequencies(writer, data, 1)
	printFrequencies(writer, data, 2)
	printSampleCount(writer, data, "GGT")
	printSampleCount(writer, data, "GGTA")
	printSampleCount(writer, data, "GGTATT")
	printSampleCount(writer, data, "GGTATTTTAATT")
	printSampleCount(writer, data, "GGTATTTTAATTTATAGT")
	writer.Flush()
}
