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

func CreateBottomUp(depth uint) *BinaryTree {
	if depth > 0 {
		return NewBinaryTree(CreateBottomUp((depth - 1)), CreateBottomUp((depth - 1)))
	} else {
		return NewBinaryTree(nil, nil)
	}
}

func main() {
	if len(os.Args) != 2 {
		fmt.Fprintln(os.Stderr, "Usage: binarytree [depth]")
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

	{
		stretchDepth := maxDepth + 1
		stretchTree := CreateBottomUp(stretchDepth)
		fmt.Printf("stretch tree of depth %d\t check: %d\n", stretchDepth, stretchTree.CountNodes())
	}

	longLivedTree := CreateBottomUp(maxDepth)

	var check uint
	var iterations int
	for depth := minDepth; depth <= maxDepth; depth += 2 {
		iterations = 1 << (maxDepth - depth + minDepth)
		check = 0
		for i := 1; i <= iterations; i++ {
			tempTree := CreateBottomUp(depth)
			check += tempTree.CountNodes()
		}
		fmt.Printf("%d\t trees of depth %d\t check: %d\n", iterations, depth, check)
	}

	fmt.Printf("long lived tree of depth %d\t check: %d\n", maxDepth, longLivedTree.CountNodes())
}
