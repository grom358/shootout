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

func (p PairList) Len() int           { return len(p) }
func (p PairList) Less(i, j int) bool { return p[i].Value > p[j].Value }
func (p PairList) Swap(i, j int)      { p[i], p[j] = p[j], p[i] }

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

func printFrequencies(data string, k int) {
	counts := countNucleotides(data, k)
	total := 0
	for _, value := range counts {
		total += value
	}

	sortedEntries := sortMapByValue(counts)

	for _, entry := range sortedEntries {
		frequency := float64(entry.Value) / float64(total) * 100.0
		fmt.Printf("%s %.3f\n", strings.ToUpper(entry.Key), frequency)
	}
	fmt.Println()
}

func printSampleCount(data string, sample string) {
	k := len(sample)
	counts := countNucleotides(data, k)
	sampleLower := strings.ToLower(sample)
	count, found := counts[sampleLower]
	if !found {
		count = 0
	}
	fmt.Printf("%d\t%s\n", count, sample)
}

func main() {
	reader := bufio.NewReader(os.Stdin)
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

	printFrequencies(data, 1)
	printFrequencies(data, 2)
	printSampleCount(data, "GGT")
	printSampleCount(data, "GGTA")
	printSampleCount(data, "GGTATT")
	printSampleCount(data, "GGTATTTTAATT")
	printSampleCount(data, "GGTATTTTAATTTATAGT")
}
