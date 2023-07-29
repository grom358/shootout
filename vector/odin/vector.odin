package main

import "core:fmt"

seed: int = 42
IM :: 139968
IMF :: 139968.0
IA :: 3877
IC :: 29573

random_next :: proc(max: int) -> int {
	seed = (seed * IA + IC) % IM
	return int(f64(max) * f64(seed) / IMF)
}

MAX :: 100
SIZE :: 200_000_000

main :: proc() {
	numbers := make([dynamic]int, 0, 16)
	for i := 0; i < SIZE; i += 1 {
		append(&numbers, random_next(MAX))
	}

	sum: int = 0
	for i := 0; i < 1000; i += 1 {
		sum += numbers[random_next(SIZE)]
	}

	fmt.printf("%d\n", sum)
}
