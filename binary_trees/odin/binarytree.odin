package main

import "core:fmt"
import "core:os"
import "core:strconv"

BinaryTree :: struct {
	left:  ^BinaryTree,
	right: ^BinaryTree,
}

binary_tree_bottom_up :: proc(depth: int, allocator := context.allocator) -> ^BinaryTree {
	root := new(BinaryTree, allocator)
	if depth > 0 {
		root.left = binary_tree_bottom_up(depth - 1, allocator)
		root.right = binary_tree_bottom_up(depth - 1, allocator)
	}
	return root
}

binary_tree_count_nodes :: proc(bt: ^BinaryTree) -> int {
	if bt.left != nil {
		return 1 + binary_tree_count_nodes(bt.left) + binary_tree_count_nodes(bt.right)
	} else {
		return 1
	}
}

binary_tree_free :: proc(bt: ^BinaryTree, allocator := context.allocator) {
	if bt.left != nil {
		binary_tree_free(bt.left, allocator)
	}
	if bt.right != nil {
		binary_tree_free(bt.right, allocator)
	}
	free(bt, allocator)
}

main :: proc() {
	if len(os.args) != 2 {
		fmt.fprintf(os.stderr, "Usage: binarytree <depth>\n")
		os.exit(1)
	}
	n, ok := strconv.parse_int(os.args[1])
	if !ok || n < 0 {
		fmt.fprintf(os.stderr, "Invalid depth!\n")
		os.exit(1)
	}

	MIN_DEPTH :: 4
	max_depth := n if n > MIN_DEPTH + 2 else MIN_DEPTH + 2

	{
		stretch_depth := max_depth + 1
		stretch_tree := binary_tree_bottom_up(stretch_depth, context.temp_allocator)
		defer free_all(context.temp_allocator)
		stretch_check := binary_tree_count_nodes(stretch_tree)
		fmt.printf("stretch tree of depth %d\t check: %d\n", stretch_depth, stretch_check)
	}

	long_lived_tree := binary_tree_bottom_up(max_depth)
	defer binary_tree_free(long_lived_tree)

	for depth := MIN_DEPTH; depth <= max_depth; depth += 2 {
		check := 0
		iterations: uint = 1 << uint(max_depth - depth + MIN_DEPTH)
		for i: uint = 1; i <= iterations; i += 1 {
			temp_tree := binary_tree_bottom_up(depth, context.temp_allocator)
			check += binary_tree_count_nodes(temp_tree)
			free_all(context.temp_allocator)
		}
		fmt.printf("%d\t trees of depth %d\t check: %d\n", iterations, depth, check)
	}

	long_lived_check := binary_tree_count_nodes(long_lived_tree)
	fmt.printf("long lived tree of depth %d\t check: %d\n", max_depth, long_lived_check)
}
