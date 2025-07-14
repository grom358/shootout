package main

import "core:bufio"
import "core:fmt"
import "core:strconv"
import "core:os"

main :: proc() {
	if len(os.args) != 3 {
		fmt.fprintf(os.stderr, "Usage: mandelbrot [size] [output-file]\n")
		os.exit(1)
	}
	n, ok := strconv.parse_int(os.args[1])
	if !ok || n < 0 {
		fmt.fprintf(os.stderr, "Invalid size!\n")
		os.exit(1)
	}
	h := n
	w := n
	iterations :: 50
	limit_sq :: 4.0
	bit_num := 0
	byte_acc: byte = 0

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
	writer := bufio.writer_to_writer(&buf_writer)

	fmt.wprintf(writer, "P4\n%d %d\n", w, h)

	for y := 0; y < h; y += 1 {
		Ci := 2.0 * f64(y) / f64(h) - 1.0
		for x := 0; x < w; x += 1 {
			Zr := 0.0
			Zi := 0.0
			Tr := 0.0
			Ti := 0.0
			Cr := 2.0 * f64(x) / f64(w) - 1.5
			for i := 0; i < iterations && (Tr + Ti <= limit_sq); i += 1 {
				Zi = 2.0 * Zr * Zi + Ci
				Zr = Tr - Ti + Cr
				Tr = Zr * Zr
				Ti = Zi * Zi
			}

			byte_acc <<= 1
			if Tr + Ti <= limit_sq {
				byte_acc |= 0x01
			}

			bit_num += 1

			if bit_num == 8 {
				bufio.writer_write_byte(&buf_writer, byte_acc)
				byte_acc = 0
				bit_num = 0
			} else if x == w - 1 {
				byte_acc <<= 8 - byte(w % 8)
				bufio.writer_write_byte(&buf_writer, byte_acc)
				byte_acc = 0
				bit_num = 0
			}
		}
	}
	bufio.writer_flush(&buf_writer)
}
