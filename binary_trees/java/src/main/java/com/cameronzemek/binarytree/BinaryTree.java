package com.cameronzemek.binarytree;

public class BinaryTree {
  BinaryTree left;
  BinaryTree right;

  BinaryTree(BinaryTree left, BinaryTree right) {
    this.left = left;
    this.right = right;
  }

  public int countNodes() {
    if (left == null) {
      return 1;
    } else {
      return 1 + left.countNodes() + right.countNodes();
    }
  }

  public static BinaryTree bottomUp(int depth) {
    if (depth > 0) {
      return new BinaryTree(bottomUp(depth - 1),
                            bottomUp(depth - 1));
    } else {
      return new BinaryTree(null, null);
    }
  }
}
