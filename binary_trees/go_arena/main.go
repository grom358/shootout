package main

import (
	"fmt"
	"os"
	"strconv"
)

type BinaryTree struct {
	left  *BinaryTree
	right *BinaryTree
}

func NewBinaryTree(left, right *BinaryTree) *BinaryTree {
	return &BinaryTree{left: left, right: right}
}

func (bt *BinaryTree) CountNodes() uint {
	if bt.left == nil {
		return 1
	} else {
		return 1 + bt.left.CountNodes() + bt.right.CountNodes()
	}
}

func CreateBottomUp(depth uint, arena *BinaryTreeArena) *BinaryTree {
	if depth > 0 {
		return arena.CreateNode(
			CreateBottomUp(depth-1, arena),
			CreateBottomUp(depth-1, arena),
		)
	}
	return arena.CreateNode(nil, nil)
}

type BinaryTreeArena struct {
	buffer   []BinaryTree
	capacity int
	size     int
}

func NewArena(capacity int) *BinaryTreeArena {
	return &BinaryTreeArena{
		buffer:   make([]BinaryTree, capacity),
		capacity: capacity,
		size:     0,
	}
}

func (arena *BinaryTreeArena) CreateNode(left, right *BinaryTree) *BinaryTree {
	if arena.size >= arena.capacity {
		panic("Arena out of memory")
	}
	node := &arena.buffer[arena.size]
	arena.size++
	node.left = left
	node.right = right
	return node
}

func (arena *BinaryTreeArena) Reset() {
	arena.size = 0
}

func main() {
	if len(os.Args) != 2 {
		fmt.Fprintln(os.Stderr, "Usage: binarytree <depth>")
		os.Exit(1)
	}

	N, err := strconv.ParseUint(os.Args[1], 10, 32)
	if err != nil {
		fmt.Fprintln(os.Stderr, "Invalid depth argument")
		os.Exit(1)
	}

	var minDepth, maxDepth uint
	minDepth = 4
	maxDepth = uint(N)
	if (minDepth + 2) > maxDepth {
		maxDepth = minDepth + 2
	}

	maxNodes := (1 << (maxDepth + 2)) - 1
	arena := NewArena(maxNodes)

	{
		stretchDepth := maxDepth + 1
		stretchTree := CreateBottomUp(stretchDepth, arena)
		fmt.Printf("stretch tree of depth %d\t check: %d\n", stretchDepth, stretchTree.CountNodes())
		arena.Reset()
	}

	longLivedArena := NewArena((1 << (maxDepth + 1)) - 1)
	longLivedTree := CreateBottomUp(maxDepth, longLivedArena)

	var check uint
	var iterations int
	for depth := minDepth; depth <= maxDepth; depth += 2 {
		iterations = 1 << (maxDepth - depth + minDepth)
		check = 0
		for i := 1; i <= iterations; i++ {
			tempTree := CreateBottomUp(depth, arena)
			check += tempTree.CountNodes()
			arena.Reset()
		}
		fmt.Printf("%d\t trees of depth %d\t check: %d\n", iterations, depth, check)
	}

	fmt.Printf("long lived tree of depth %d\t check: %d\n", maxDepth, longLivedTree.CountNodes())
}
