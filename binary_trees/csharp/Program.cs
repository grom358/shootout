namespace BinaryTreeApp {
public class BinaryTree {
  public BinaryTree? left;
  public BinaryTree? right;

  public BinaryTree(BinaryTree? left, BinaryTree? right) {
    this.left = left;
    this.right = right;
  }

  public int CountNodes() {
    if (left == null || right == null) {
      return 1;
    } else {
      return 1 + left.CountNodes() + right.CountNodes();
    }
  }

  public static BinaryTree BottomUp(int depth) {
    if (depth > 0) {
      return new BinaryTree(BottomUp(depth - 1), BottomUp(depth - 1));
    } else {
      return new BinaryTree(null, null);
    }
  }
}

class Program {
  static void Main(string[] args) {
    if (args.Length != 1 || !int.TryParse(args[0], out int depth)) {
      Console.WriteLine("Usage: binarytree [depth]");
      return;
    }

    int N = int.Parse(args[0]);
    int minDepth = 4;
    int maxDepth = minDepth + 2 > N ? minDepth + 2 : N;

    {
      int stretchDepth = maxDepth + 1;
      BinaryTree stretchTree = BinaryTree.BottomUp(stretchDepth);
      Console.WriteLine(
          $"stretch tree of depth {stretchDepth}\t check: {stretchTree.CountNodes()}");
    }

    BinaryTree longLivedTree = BinaryTree.BottomUp(maxDepth);

    long check = 0;
    long iterations;
    for (int currentDepth = minDepth; currentDepth <= maxDepth;
         currentDepth += 2) {
      iterations = 1L << (maxDepth - currentDepth + minDepth);
      check = 0;
      for (long i = 1; i <= iterations; i++) {
        BinaryTree tempTree = BinaryTree.BottomUp(currentDepth);
        check += tempTree.CountNodes();
      }
      Console.WriteLine(
          $"{iterations}\t trees of depth {currentDepth}\t check: {check}");
    }

    Console.WriteLine(
        $"long lived tree of depth {maxDepth}\t check: {longLivedTree.CountNodes()}");
  }
}
}
