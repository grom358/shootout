package main

import "core:io"
import "core:bufio"
import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"

seed: int = 42
IM :: 139968
IA :: 3877
IC :: 29573

random_number :: proc() -> f64 {
	seed = (seed * IA + IC) % IM
	return f64(seed) / IM
}

WIDTH :: 60

repeat_fasta :: proc(writer: ^bufio.Writer, header: string, $s: string, repeat: int) {
	bufio.writer_write_string(writer, header)
	pos := 0
	count := repeat
	s_len := len(s)
	ss := s + s
	for count > 0 {
		length := min(WIDTH, count)
		bufio.writer_write_string(writer, ss[pos:pos + length])
		bufio.writer_write_byte(writer, '\n')
		pos += length
		if pos > s_len {
			pos -= s_len
		}
		count -= length
	}
}

AminoAcid :: struct {
	p: f64,
	c: byte,
}

accumulate_probabilities :: proc(genelist: []AminoAcid) {
	cp: f64 = 0.0
	for _, i in genelist {
		cp += genelist[i].p
		genelist[i].p = cp
	}
}

random_fasta :: proc(writer: ^bufio.Writer, header: string, genelist: []AminoAcid, repeat: int) {
	bufio.writer_write_string(writer, header)
	accumulate_probabilities(genelist)
	buffer: [WIDTH + 1]byte
	builder := strings.builder_from_bytes(buffer[:])
	count := repeat
	for count > 0 {
		length := min(WIDTH, count)
		for pos in 0 ..< length {
			r := random_number()
			for gene in genelist {
				if gene.p >= r {
					strings.write_byte(&builder, gene.c)
					break
				}
			}
		}
		strings.write_byte(&builder, '\n')
		bufio.writer_write_string(writer, strings.to_string(builder))
		strings.builder_reset(&builder)
		count -= length
	}
}

main :: proc() {
	if len(os.args) != 3 {
		fmt.fprintf(os.stderr, "Usage: fasta <size> <output.txt>\n")
		os.exit(1)
	}
	n, ok := strconv.parse_int(os.args[1])
	if !ok || n < 0 {
		fmt.fprintf(os.stderr, "Invalid size!\n")
		os.exit(1)
	}

	output_path := os.args[2]
	file_out, err := os.open(output_path, os.O_CREATE | os.O_TRUNC | os.O_WRONLY, 0o644)
	defer os.close(file_out)
	if err != nil {
		fmt.fprintln(os.stderr, "Error opening output:", err)
		os.exit(1)
	}
	out := os.stream_from_handle(file_out)
	buf_writer: bufio.Writer
	bufio.writer_init(&buf_writer, out)

	alu ::
		"GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTG" +
		"GGAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGA" +
		"GACCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAA" +
		"AATACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAAT" +
		"CCCAGCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAAC" +
		"CCGGGAGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTG" +
		"CACTCCAGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA"
	repeat_fasta(&buf_writer, ">ONE Homo sapiens alu\n", alu, 2 * n)

	iub := [?]AminoAcid{
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
	random_fasta(&buf_writer, ">TWO IUB ambiguity codes\n", iub[:], 3 * n)

	homosapiens := [?]AminoAcid{
		{0.3029549426680, 'a'},
		{0.1979883004921, 'c'},
		{0.1975473066391, 'g'},
		{0.3015094502008, 't'},
	}
	random_fasta(&buf_writer, ">THREE Homo sapiens frequency\n", homosapiens[:], 5 * n)

	bufio.writer_flush(&buf_writer)
}
