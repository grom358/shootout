#include <stdio.h>
#include <stdlib.h>

typedef struct tn {
  struct tn *left;
  struct tn *right;
} BinaryTree;

BinaryTree *binary_tree_new(BinaryTree *left, BinaryTree *right) {
  BinaryTree *bt;
  bt = malloc(sizeof(BinaryTree));
  bt->left = left;
  bt->right = right;
  return bt;
}

void binary_tree_delete(BinaryTree *bt) {
  if (bt->left != NULL) {
    binary_tree_delete(bt->left);
    binary_tree_delete(bt->right);
  }
  free(bt);
}

long binary_tree_count(BinaryTree *bt) {
  if (bt->left == NULL) {
    return 1;
  } else {
    return 1 + binary_tree_count(bt->left) + binary_tree_count(bt->right);
  }
}

BinaryTree *binary_tree_bottom_up(unsigned int depth) {
  if (depth > 0) {
    return binary_tree_new(binary_tree_bottom_up(depth - 1),
                           binary_tree_bottom_up(depth - 1));
  } else {
    return binary_tree_new(NULL, NULL);
  }
}

int main(int argc, char *argv[]) {
  if (argc != 2) {
    fprintf(stderr, "Usage: binarytree <depth>\n");
    return 1;
  }
  unsigned int N = atol(argv[1]);

  unsigned int min_depth = 4;
  unsigned int max_depth = min_depth + 2 > N ? min_depth + 2 : N;

  {
    unsigned int stretch_depth = max_depth + 1;
    BinaryTree *stretch_tree = binary_tree_bottom_up(stretch_depth);
    printf("stretch tree of depth %u\t check: %li\n", stretch_depth,
           binary_tree_count(stretch_tree));
    binary_tree_delete(stretch_tree);
  }

  BinaryTree *long_lived_tree = binary_tree_bottom_up(max_depth);

  for (unsigned int depth = min_depth; depth <= max_depth; depth += 2) {
    long iterations = 1 << (max_depth - depth + min_depth);
    long check = 0;
    for (long i = 1; i <= iterations; i++) {
      BinaryTree *temp_tree = binary_tree_bottom_up(depth);
      check += binary_tree_count(temp_tree);
      binary_tree_delete(temp_tree);
    }
    printf("%li\t trees of depth %u\t check: %li\n", iterations, depth, check);
  }
  printf("long lived tree of depth %u\t check: %li\n", max_depth,
         binary_tree_count(long_lived_tree));
  return 0;
}
