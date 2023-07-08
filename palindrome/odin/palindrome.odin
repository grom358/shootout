package main

import "core:fmt"
import "core:sync"
import "core:thread"
import "core:math"

is_palindrome :: proc(number: int) -> bool {
	reversed_number := 0
	original_number := number

	n := number
	for n != 0 {
		digit := n % 10
		reversed_number = reversed_number * 10 + digit
		n /= 10
	}

	return original_number == reversed_number
}

calculate_sum :: proc(start: int, end: int, sum: ^u64, lock: ^sync.Mutex) {
	local_sum : u64 = 0
	for x in start ..= end {
		if is_palindrome(x) {
			local_sum += u64(x)
		}
	}

	sync.mutex_lock(lock)
	sum^ += local_sum
	sync.mutex_unlock(lock)
}

main :: proc() {
	start :: 100_000_000
	end :: 999_999_999
	range :: end - start

	cores :: 4
	chunk := int(math.ceil(range / f64(cores)))

	lock := sync.Mutex{}
	sum: u64 = 0

	handles: [cores]^thread.Thread
	for i in 0 ..< cores {
		thread_start := start + (chunk * i)
		thread_end := i == cores ? end : thread_start + chunk - 1
		handles[i] = thread.create_and_start_with_poly_data4(
			thread_start,
			thread_end,
			&sum,
			&lock,
			calculate_sum,
		)
	}

	for handle in handles {
		thread.join(handle)
	}
	sync.mutex_lock(&lock)
	fmt.printf("%d\n", sum)
	sync.mutex_unlock(&lock)
}
