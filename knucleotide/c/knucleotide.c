// enable POSIX extension for strdup
#define _POSIX_C_SOURCE 200809L
#include "file_readall.h"
#include "khash.h"
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

KHASH_MAP_INIT_STR(hashmap, int)

typedef struct {
  const char *key;
  int value;
} Pair;

typedef struct {
  Pair *data;
  size_t capacity;
  size_t size;
} PairList;

PairList *pair_list_create(size_t capacity) {
  PairList *list = (PairList *)malloc(sizeof(PairList));
  list->data = (Pair *)malloc(capacity * sizeof(Pair));
  list->capacity = capacity;
  list->size = 0;
  return list;
}

void pair_list_destroy(PairList *list) {
  if (list) {
    free(list->data);
    free(list);
  }
}

int compare_pair(const void *a, const void *b) {
  const Pair *pa = (const Pair *)a;
  const Pair *pb = (const Pair *)b;
  return pb->value - pa->value;
}

void pair_list_sort(PairList *list) {
  qsort(list->data, list->size, sizeof(Pair), compare_pair);
}

void pair_list_append(PairList *list, const char *key, int value) {
  if (list->size >= list->capacity) {
    list->capacity *= 2;
    list->data = (Pair *)realloc(list->data, list->capacity * sizeof(Pair));
  }

  list->data[list->size].key = key;
  list->data[list->size].value = value;
  list->size++;
}

void count_nucleotides(const char *data, int k, khash_t(hashmap) * counts) {
  kh_clear(hashmap, counts);
  int endIndex = strlen(data) - k;
  char fragment[k + 1];

  for (int i = 0; i <= endIndex; i++) {
    strncpy(fragment, &data[i], k);
    fragment[k] = '\0';
    int ret;
    khint_t iter = kh_put(hashmap, counts, fragment, &ret);
    if (ret == -1) {
      fprintf(stderr, "Error: unable to put the key in hashmap\n");
      exit(EXIT_FAILURE);
    }

    if (ret == 0) {
      kh_val(counts, iter)++;
    } else {
      kh_key(counts, iter) = strdup(fragment);
      kh_val(counts, iter) = 1;
    }
  }
}

void print_frequencies(const char *data, int k) {
  khash_t(hashmap) *counts = kh_init(hashmap);
  count_nucleotides(data, k, counts);
  int total = 0;

  PairList *sortedPairs = pair_list_create(kh_size(counts));

  for (khiter_t iter = kh_begin(counts); iter != kh_end(counts); ++iter) {
    if (!kh_exist(counts, iter))
      continue;
    total += kh_val(counts, iter);
    pair_list_append(sortedPairs, kh_key(counts, iter), kh_val(counts, iter));
  }

  pair_list_sort(sortedPairs);

  char key_upper[k + 1];
  for (size_t i = 0; i < sortedPairs->size; i++) {
    const char *key = sortedPairs->data[i].key;
    for (size_t j = 0; j < k; j++) {
      key_upper[j] = toupper(key[j]);
    }
    key_upper[k] = '\0';
    double frequency =
        (double)sortedPairs->data[i].value / (double)total * 100.0;
    printf("%s %.3f\n", key_upper, frequency);
  }
  printf("\n");

  // Clean up
  kh_destroy(hashmap, counts);
  pair_list_destroy(sortedPairs);
}

void print_sample_count(const char *data, const char *sample) {
  int k = strlen(sample);
  khash_t(hashmap) *counts = kh_init(hashmap);
  count_nucleotides(data, k, counts);
  char sample_lower[k + 1];

  for (int i = 0; i < k; i++) {
    sample_lower[i] = tolower(sample[i]);
  }
  sample_lower[k] = '\0';

  khiter_t iter = kh_get(hashmap, counts, sample_lower);
  if (iter == kh_end(counts)) {
    printf("0\t%s\n", sample);
  } else {
    printf("%d\t%s\n", kh_val(counts, iter), sample);
  }

  // Clean up
  kh_destroy(hashmap, counts);
}

int main() {
  const int max_line_length = 100;
  char *line = (char *)malloc(max_line_length);

  // Read until the header line ">THREE"
  while (fgets(line, max_line_length, stdin) != NULL) {
    if (strstr(line, ">THREE") != NULL) {
      break;
    }
  }

  // Read the DNA sequence
  char *input;
  size_t file_size;
  int ret = readall(stdin, &input, &file_size);
  if (ret != READALL_OK) {
    fprintf(stderr, "Error reading input!");
    exit(EXIT_FAILURE);
  }
  char *data = calloc(file_size, sizeof(char));
  int pos = 0;
  for (int i = 0; i < file_size; i++) {
    if (input[i] != '\n') {
      data[pos++] = input[i];
    }
  }

  print_frequencies(data, 1);
  print_frequencies(data, 2);
  print_sample_count(data, "GGT");
  print_sample_count(data, "GGTA");
  print_sample_count(data, "GGTATT");
  print_sample_count(data, "GGTATTTTAATT");
  print_sample_count(data, "GGTATTTTAATTTATAGT");

  free(line);
  free(data);

  return 0;
}
