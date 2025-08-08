#include <iostream>
#include <cassert>

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

class BinaryTreeArena {
public:
    explicit BinaryTreeArena(std::size_t capacity)
        : buffer_(static_cast<BinaryTree*>(::operator new(capacity * sizeof(BinaryTree)))),
          capacity_(capacity) {}

    ~BinaryTreeArena() {
        ::operator delete(buffer_);
    }

    BinaryTree* create(BinaryTree* left = nullptr, BinaryTree* right = nullptr) {
        assert(size_ < capacity_ && "Arena out of memory");
        void* mem = buffer_ + size_;
        ++size_;
        return new (mem) BinaryTree(left, right);
    }

    // Reset the arena (no destructors called)
    void reset() { size_ = 0; }

private:
    BinaryTree* buffer_;
    std::size_t capacity_;
    std::size_t size_ = 0;
};

BinaryTree *createBottomUp(unsigned int depth, BinaryTreeArena &arena) {
  if (depth > 0) {
    return arena.create(createBottomUp(depth - 1, arena),
                        createBottomUp(depth - 1, arena));
  } else {
    return arena.create();
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

  unsigned int maxNodes = (1 << (maxDepth + 2)) - 1;
  BinaryTreeArena arena(maxNodes);
  {
    unsigned int stretchDepth = maxDepth + 1;
    BinaryTree *stretchTree = createBottomUp(stretchDepth, arena);
    std::cout << "stretch tree of depth " << stretchDepth
              << "\t check: " << stretchTree->countNodes() << std::endl;
    arena.reset();
  }

  BinaryTreeArena longLivedPool((1 << (maxDepth + 1)) - 1);
  BinaryTree *longLivedTree = createBottomUp(maxDepth, longLivedPool);

  long check = 0;
  long iterations;
  for (unsigned int depth = minDepth; depth <= maxDepth; depth += 2) {
    iterations = 1L << (maxDepth - depth + minDepth);
    check = 0;
    for (long i = 1; i <= iterations; i++) {
      BinaryTree *tempTree = createBottomUp(depth, arena);
      check += tempTree->countNodes();
      arena.reset();
    }
    std::cout << iterations << "\t trees of depth " << depth
              << "\t check: " << check << std::endl;
  }
  std::cout << "long lived tree of depth " << maxDepth
            << "\t check: " << longLivedTree->countNodes() << std::endl;

  return 0;
}
