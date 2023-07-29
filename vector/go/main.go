package main

import (
	"fmt"
)

const (
	IM  = 139968
	IMF = 139968.0
	IA  = 3877
	IC  = 29573
)

var seed int = 42

func RandomNext(max int) int {
	seed = ((seed * IA) + IC) % IM
	return int(float64(max) * float64(seed) / IMF)
}

func main() {
	numbers := make([]int, 0, 16)
	max := 100
	size := 200000000

	for i := 0; i < size; i++ {
		numbers = append(numbers, RandomNext(max))
	}

	sum := 0
	for i := 0; i < 1000; i++ {
		sum += numbers[RandomNext(size)]
	}

	fmt.Println(sum)
}
