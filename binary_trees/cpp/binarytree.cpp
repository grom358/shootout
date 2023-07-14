#include <iostream>
#include <memory>

class BinaryTree {
private:
  std::unique_ptr<BinaryTree> left;
  std::unique_ptr<BinaryTree> right;

public:
  BinaryTree(std::unique_ptr<BinaryTree> left = nullptr,
             std::unique_ptr<BinaryTree> right = nullptr)
      : left(std::move(left)), right(std::move(right)) {}

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

  static std::unique_ptr<BinaryTree> createBottomUp(unsigned int depth) {
    if (depth > 0) {
      return std::make_unique<BinaryTree>(createBottomUp(depth - 1),
                                          createBottomUp(depth - 1));
    } else {
      return std::make_unique<BinaryTree>();
    }
  }
};

int main(int argc, char *argv[]) {
  if (argc != 2) {
    std::cerr << "Usage: binarytree [depth]\n";
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

  unsigned int stretchDepth = maxDepth + 1;
  std::unique_ptr<BinaryTree> stretchTree = BinaryTree::createBottomUp(stretchDepth);
  std::cout << "stretch tree of depth " << stretchDepth
            << "\t check: " << stretchTree->countNodes() << std::endl;

  std::unique_ptr<BinaryTree> longLivedTree = BinaryTree::createBottomUp(maxDepth);

  long check = 0;
  long iterations;
  for (unsigned int depth = minDepth; depth <= maxDepth; depth += 2) {
    iterations = 1L << (maxDepth - depth + minDepth);
    check = 0;
    for (long i = 1; i <= iterations; i++) {
      std::unique_ptr<BinaryTree> tempTree = BinaryTree::createBottomUp(depth);
      check += tempTree->countNodes();
    }
    std::cout << iterations << "\t trees of depth " << depth
              << "\t check: " << check << std::endl;
  }
  std::cout << "long lived tree of depth " << maxDepth
            << "\t check: " << longLivedTree->countNodes() << std::endl;

  return 0;
}
