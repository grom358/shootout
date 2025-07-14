package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"

	"github.com/grom358/zscript/lexer"
)

func main() {
	if len(os.Args) < 3 {
		fmt.Fprintln(os.Stderr, "Usage: zscript <input.zs> <output.csv>")
		os.Exit(1)
	}

	inputPath := os.Args[1]
	outputPath := os.Args[2]

	b, err := os.ReadFile(inputPath)
	if err != nil {
		fmt.Fprintln(os.Stderr, "Error reading input:", err)
		os.Exit(1)
	}
	s := string(b)

	outFile, err := os.Create(outputPath)
	if err != nil {
		fmt.Fprintln(os.Stderr, "Error creating output:", err)
		os.Exit(1)
	}
	defer outFile.Close()

	l := lexer.New(s)
	writer := bufio.NewWriterSize(outFile, 4096)
	for t := l.NextToken(); t.Type != lexer.Eof; t = l.NextToken() {
		printToken(writer, t)
	}
	writer.Flush()
}

func printToken(writer *bufio.Writer, t lexer.Token) {
	s := t.Literal
	if t.Type == lexer.String {
		s = s[1 : len(s)-1]
	}
	if t.Type == lexer.String || t.Type == lexer.Comment {
		s = strings.ReplaceAll(s, "\"", "\"\"")
	}
	// The format machinery is slow. Instead of:
	// fmt.Fprintf(writer, "%d,%d,\"%s\",\"%s\"\n", t.LineNo, t.ColNo, s, t.Type)
	// format the CSV record manually.
	writer.WriteString(strconv.FormatUint(uint64(t.LineNo), 10))
	writer.WriteString(",")
	writer.WriteString(strconv.FormatUint(uint64(t.ColNo), 10))
	writer.WriteString(",\"")
	writer.WriteString(s)
	writer.WriteString("\",\"")
	writer.WriteString(string(t.Type))
	writer.WriteString("\"\n")
}
