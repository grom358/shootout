package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"strconv"
	"strings"

	"github.com/grom358/zscript/lexer"
)

func main() {
	b, err := io.ReadAll(os.Stdin)
	if err != nil {
		fmt.Println(err)
		return
	}
	s := string(b)
	l := lexer.New(s)
	writer := bufio.NewWriterSize(os.Stdout, 4096)
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
