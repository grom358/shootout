#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

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

typedef struct {
  BinaryTree *buffer;
  size_t capacity;
  size_t size;
} BinaryTreeArena;

BinaryTreeArena* arena_create(size_t capacity) {
  BinaryTreeArena* arena = malloc(sizeof(BinaryTreeArena));
  if (!arena) return NULL;
  arena->buffer = malloc(capacity * sizeof(BinaryTree));
  if (!arena->buffer) {
    free(arena);
    return NULL;
  }
  arena->capacity = capacity;
  arena->size = 0;
  return arena;
}

void arena_destroy(BinaryTreeArena* arena) {
  if (!arena) return;
  free(arena->buffer);
  free(arena);
}

BinaryTree* arena_create_node(BinaryTreeArena* arena, BinaryTree* left, BinaryTree* right) {
  assert(arena->size < arena->capacity && "Arena out of memory");
  BinaryTree* node = &arena->buffer[arena->size++];
  node->left = left;
  node->right = right;
  return node;
}

void arena_reset(BinaryTreeArena* arena) {
  arena->size = 0;
}

BinaryTree *binary_tree_bottom_up(unsigned int depth,
                                  BinaryTreeArena* arena) {
  if (depth > 0) {
    return arena_create_node(arena,
                             binary_tree_bottom_up(depth - 1, arena),
                             binary_tree_bottom_up(depth - 1, arena));
  } else {
    return arena_create_node(arena, NULL, NULL);
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

  unsigned int max_nodes = (1 << (max_depth + 2)) - 1;
  BinaryTreeArena* arena = arena_create(max_nodes);
  {
    unsigned int stretch_depth = max_depth + 1;
    BinaryTree *stretchTree = binary_tree_bottom_up(stretch_depth, arena);
    printf("stretch tree of depth %u\t check: %li\n", stretch_depth,
           binary_tree_count(stretchTree));
    arena_reset(arena);
  }

  BinaryTreeArena* long_lived_arena = arena_create((1 << (max_depth + 1)) - 1);
  BinaryTree* long_lived_tree = binary_tree_bottom_up(max_depth, long_lived_arena);

  for (unsigned int depth = min_depth; depth <= max_depth; depth += 2) {
    long iterations = 1 << (max_depth - depth + min_depth);
    long check = 0;
    for (long i = 1; i <= iterations; i++) {
      BinaryTree *temp_tree = binary_tree_bottom_up(depth, arena);
      check += binary_tree_count(temp_tree);
      arena_reset(arena);
    }
    printf("%li\t trees of depth %u\t check: %li\n", iterations, depth, check);
  }

  printf("long lived tree of depth %u\t check: %li\n", max_depth,
         binary_tree_count(long_lived_tree));

  return 0;
}
