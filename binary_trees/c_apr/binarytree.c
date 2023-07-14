// clang-format off
#include <linux/limits.h>
// clang-format on
#include <apr_pools.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct tn {
  struct tn *left;
  struct tn *right;
} BinaryTree;

long binary_tree_count(BinaryTree *bt) {
  if (bt->left == NULL) {
    return 1;
  } else {
    return 1 + binary_tree_count(bt->left) + binary_tree_count(bt->right);
  }
}

BinaryTree *binary_tree_bottom_up(unsigned int depth,
                                  apr_pool_t *const memory_pool) {
  BinaryTree *const root = apr_pcalloc(memory_pool, sizeof(BinaryTree));
  if (depth > 0) {
    root->left = binary_tree_bottom_up(depth - 1, memory_pool);
    root->right = binary_tree_bottom_up(depth - 1, memory_pool);
  }
  return root;
}

int main(int argc, char *argv[]) {
  if (argc != 2) {
    fprintf(stderr, "Usage: binarytree [depth]\n");
    return 1;
  }

  apr_initialize();

  unsigned int N = atol(argv[1]);

  unsigned int min_depth = 4;
  unsigned int max_depth = min_depth + 2 > N ? min_depth + 2 : N;

  apr_pool_t *memory_pool;
  apr_pool_create_unmanaged(&memory_pool);

  {
    unsigned int stretch_depth = max_depth + 1;
    BinaryTree *stretchTree = binary_tree_bottom_up(stretch_depth, memory_pool);
    printf("stretch tree of depth %u\t check: %li\n", stretch_depth,
           binary_tree_count(stretchTree));
    apr_pool_destroy(memory_pool);
  }

  apr_pool_create_unmanaged(&memory_pool);
  BinaryTree *longLivedTree = binary_tree_bottom_up(max_depth, memory_pool);

  apr_pool_t *temp_memory_pool;
  apr_pool_create_unmanaged(&temp_memory_pool);
  for (unsigned int depth = min_depth; depth <= max_depth; depth += 2) {
    long iterations = 1 << (max_depth - depth + min_depth);
    long check = 0;
    for (long i = 1; i <= iterations; i++) {
      BinaryTree *temp_tree = binary_tree_bottom_up(depth, temp_memory_pool);
      check += binary_tree_count(temp_tree);
      apr_pool_clear(temp_memory_pool);
    }
    printf("%li\t trees of depth %u\t check: %li\n", iterations, depth, check);
  }
  apr_pool_destroy(temp_memory_pool);

  printf("long lived tree of depth %u\t check: %li\n", max_depth,
         binary_tree_count(longLivedTree));
  apr_pool_destroy(memory_pool);

  apr_terminate();
  return 0;
}
