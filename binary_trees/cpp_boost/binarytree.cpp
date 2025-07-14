#include <boost/pool/object_pool.hpp>
#include <iostream>
#include <memory>

class BinaryTree {
private:
  BinaryTree *left;
  BinaryTree *right;

public:
  BinaryTree(BinaryTree *left = nullptr, BinaryTree *right = nullptr)
      : left(left), right(right) {}

  ~BinaryTree() {
    left = nullptr;
    right = nullptr;
  }

  long countNodes() const {
    if (left == nullptr) {
      return 1;
    } else {
      return 1 + left->countNodes() + right->countNodes();
    }
  }
};

typedef boost::object_pool<BinaryTree> BinaryTreePool;

BinaryTree *createBottomUp(unsigned int depth, BinaryTreePool &pool) {
  if (depth > 0) {
    return pool.construct(createBottomUp(depth - 1, pool),
                          createBottomUp(depth - 1, pool));
  } else {
    return pool.construct();
  }
}

int main(int argc, char *argv[]) {
  if (argc != 2) {
    std::cerr << "Usage: binarytree <depth>\n";
    return 1;
  }
  unsigned int N, minDepth, maxDepth;
  N = std::atol(argv[1]);

  minDepth = 4;
  if (minDepth + 2 > N) {
    maxDepth = minDepth + 2;
  } else {
    maxDepth = N;
  }

  {
    BinaryTreePool pool;
    unsigned int stretchDepth = maxDepth + 1;
    BinaryTree *stretchTree = createBottomUp(stretchDepth, pool);
    std::cout << "stretch tree of depth " << stretchDepth
              << "\t check: " << stretchTree->countNodes() << std::endl;
  }

  BinaryTreePool longLivedPool;
  BinaryTree *longLivedTree = createBottomUp(maxDepth, longLivedPool);

  long check = 0;
  long iterations;
  for (unsigned int depth = minDepth; depth <= maxDepth; depth += 2) {
    iterations = 1L << (maxDepth - depth + minDepth);
    check = 0;
    for (long i = 1; i <= iterations; i++) {
      BinaryTreePool pool;
      BinaryTree *tempTree = createBottomUp(depth, pool);
      check += tempTree->countNodes();
    }
    std::cout << iterations << "\t trees of depth " << depth
              << "\t check: " << check << std::endl;
  }
  std::cout << "long lived tree of depth " << maxDepth
            << "\t check: " << longLivedTree->countNodes() << std::endl;

  return 0;
}
