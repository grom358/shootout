package main

import "core:fmt"
import "core:strings"
import "core:os"
import "core:bufio"
import "core:slice"

count_nucleotides :: proc(data: string, k: int) -> map[string]int {
	counts := map[string]int{}
	end_index := len(data) - k
	for i := 0; i <= end_index; i += 1 {
		fragment := data[i:i + k]
		counts[fragment] += 1
	}
	return counts
}

Pair :: struct {
	key:   string,
	value: int,
}

pair_less :: proc(i, j: Pair) -> bool {
	return j.value < i.value
}

print_frequencies :: proc(writer: os.Handle, data: string, k: int) {
	counts := count_nucleotides(data, k)
	defer delete(counts)
	total := 0

	sorted_pairs := make([dynamic]Pair, 0, len(counts))
	defer delete(sorted_pairs)
	{
		for key, value in counts {
			total += value
			append(&sorted_pairs, Pair{key, value})
		}
	}
	slice.sort_by(sorted_pairs[0:], pair_less)

	defer free_all(context.temp_allocator)
	for pair in sorted_pairs {
		frequency := f64(pair.value) / f64(total) * 100.0
		key_upper := strings.to_upper(pair.key, context.temp_allocator)
		fmt.fprintf(writer, "%s %.3f\n", key_upper, frequency)
	}
	fmt.fprintf(writer, "\n")
}

print_sample_count :: proc(writer: os.Handle, data: string, sample: string) {
	k := len(sample)
	counts := count_nucleotides(data, k)
	defer delete(counts)
	sample_lower := strings.to_lower(sample)
	count, found := counts[sample_lower]
	if !found {
		fmt.fprintf(writer, "0\t%s\n", sample)
	} else {
		fmt.fprintf(writer, "%d\t%s\n", count, sample)
	}
}

THREE :: ">THREE"
BYTES_PER_MB :: 1024 * 1024

main :: proc() {
	if len(os.args) != 3 {
		fmt.fprintln(os.stderr, "Usage: knucleotide <input.txt> <output.txt>")
		os.exit(1)
	}

	input_path := os.args[1]
	output_path := os.args[2]

	file_in, in_err := os.open(input_path)
	defer os.close(file_in)
	if in_err != nil {
		fmt.println("Error opening input:", in_err)
		os.exit(1)
	}

	file_out, err := os.open(output_path, os.O_CREATE | os.O_TRUNC | os.O_WRONLY, 0o644)
	defer os.close(file_out)
	if err != nil {
		fmt.println("Error opening output:", err)
		os.exit(1)
	}

	builder: strings.Builder
	strings.builder_init_len_cap(&builder, 0, 128 * BYTES_PER_MB)
	defer strings.builder_destroy(&builder)
	data: string
	{
		buf_reader: bufio.Reader
		buffer := [100]u8{}
		bufio.reader_init_with_buf(&buf_reader, os.stream_from_handle(file_in), buffer[0:])

		for {
			line_bytes, err := bufio.reader_read_slice(&buf_reader, '\n')
			if err != nil {
				break
			}
			line := string(line_bytes)
			if line[0:len(THREE)] == THREE {
				break
			}
		}

		for {
			line_bytes, err := bufio.reader_read_slice(&buf_reader, '\n')
			if err != nil {
				break
			}
			line := strings.trim_right(string(line_bytes), "\n")
			strings.write_string(&builder, line)
		}
		data = strings.to_string(builder)
	}

	print_frequencies(file_out, data, 1)
	print_frequencies(file_out, data, 2)
	print_sample_count(file_out, data, "GGT")
	print_sample_count(file_out, data, "GGTA")
	print_sample_count(file_out, data, "GGTATT")
	print_sample_count(file_out, data, "GGTATTTTAATT")
	print_sample_count(file_out, data, "GGTATTTTAATTTATAGT")
}
