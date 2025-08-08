package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:mem"

BinaryTree :: struct {
	left:  ^BinaryTree,
	right: ^BinaryTree,
}

binary_tree_bottom_up :: proc(depth: uint, allocator: mem.Allocator) -> ^BinaryTree {
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

size_for_depth :: proc(depth: uint) -> uint {
	num_node : uint = (1 << (depth + 1)) - 1;
	return num_node * size_of(BinaryTree)
}

main :: proc() {
	if len(os.args) != 2 {
		fmt.fprintf(os.stderr, "Usage: binarytree <depth>\n")
		os.exit(1)
	}
	n, ok := strconv.parse_uint(os.args[1])
	if !ok || n < 0 {
		fmt.fprintf(os.stderr, "Invalid depth!\n")
		os.exit(1)
	}

	MIN_DEPTH : uint : 4
	max_depth := n if n > MIN_DEPTH + 2 else MIN_DEPTH + 2

	arena: mem.Arena
	storage := make([]u8, size_for_depth(max_depth + 1))
	defer delete(storage)
	mem.arena_init(&arena, storage)
	arena_allocator := mem.arena_allocator(&arena)

	{
		stretch_depth := max_depth + 1
		stretch_tree := binary_tree_bottom_up(stretch_depth, arena_allocator)
		defer free_all(arena_allocator)
		stretch_check := binary_tree_count_nodes(stretch_tree)
		fmt.printf("stretch tree of depth %d\t check: %d\n", stretch_depth, stretch_check)
	}

	long_lived_arena: mem.Arena
	long_lived_storage := make([]u8, size_for_depth(max_depth))
	defer delete(long_lived_storage)
	mem.arena_init(&long_lived_arena, long_lived_storage)
	long_lived_allocator := mem.arena_allocator(&long_lived_arena)
	long_lived_tree := binary_tree_bottom_up(max_depth, long_lived_allocator)

	for depth := MIN_DEPTH; depth <= max_depth; depth += 2 {
		check := 0
		iterations: uint = 1 << uint(max_depth - depth + MIN_DEPTH)
		for i: uint = 1; i <= iterations; i += 1 {
			temp_tree := binary_tree_bottom_up(depth, arena_allocator)
			check += binary_tree_count_nodes(temp_tree)
			free_all(arena_allocator)
		}
		fmt.printf("%d\t trees of depth %d\t check: %d\n", iterations, depth, check)
	}

	long_lived_check := binary_tree_count_nodes(long_lived_tree)
	fmt.printf("long lived tree of depth %d\t check: %d\n", max_depth, long_lived_check)
}
