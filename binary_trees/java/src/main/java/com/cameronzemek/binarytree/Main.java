package com.cameronzemek.binarytree;

public class Main {
  public static void main(String[] args) throws Exception {
    if (args.length != 1) {
      System.err.println("Usage: binarytree <depth>");
      System.exit(1);
    }
    int N = Integer.parseInt(args[0]);
    int minDepth = 4;
    int maxDepth = N;
    if (minDepth + 2 > N) {
      maxDepth = minDepth + 2;
    }

    int stretchDepth = maxDepth + 1;
    BinaryTree stretchTree = BinaryTree.bottomUp(stretchDepth);
    System.out.printf("stretch tree of depth %d\t check: %d\n", stretchDepth,
                      stretchTree.countNodes());

    BinaryTree longLivedTree = BinaryTree.bottomUp(maxDepth);

    for (int depth = minDepth; depth <= maxDepth; depth += 2) {
      int iterations = 1 << (maxDepth - depth + minDepth);
      int check = 0;
      for (long i = 0; i < iterations; i++) {
        final BinaryTree tempTree = BinaryTree.bottomUp(depth);
        check += tempTree.countNodes();
      }
      System.out.printf("%d\t trees of depth %d\t check: %d\n", iterations,
                        depth, check);
    }

    System.out.printf("long lived tree of depth %d\t check: %d\n", maxDepth,
                      longLivedTree.countNodes());
  }
}
