#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define IM 139968
#define IMF 139968.0
#define IA 3877
#define IC 29573
int seed = 42;

int rand_next(int max) {
  seed = (seed * IA + IC) % IM;
  return (int)(max * (seed / IMF));
}

#define DS_DEFAULT_INIT_CAPACITY 16

typedef struct {
  int *data;
  size_t size;
  size_t capacity;
} DynamicArray;

DynamicArray *da_create() {
  DynamicArray *arr = (DynamicArray *)malloc(sizeof(DynamicArray));
  if (arr == NULL) {
    printf("Memory allocation failed.\n");
    return NULL;
  }

  arr->data = NULL;
  arr->size = 0;
  arr->capacity = 0;
  return arr;
}

int ds_append(DynamicArray *arr, int value) {
  if (arr->size >= arr->capacity) {
    size_t new_cap =
        arr->capacity == 0 ? DS_DEFAULT_INIT_CAPACITY : arr->capacity * 2;
    int *new_data = (int *)realloc(arr->data, new_cap * sizeof(int));
    if (new_data == NULL) {
      return 0;
    }
    arr->data = new_data;
    arr->capacity = new_cap;
  }

  arr->data[arr->size++] = value;
  return 1;
}

void ds_destroy(DynamicArray *arr) {
  free(arr->data);
  free(arr);
}

#define MAX 100
#define SIZE 200000000

int main() {
  DynamicArray *numbers = da_create();

  for (int i = 0; i < SIZE; i++) {
    ds_append(numbers, rand_next(MAX));
  }

  int sum = 0;
  for (int i = 0; i < 1000; i++) {
    sum += numbers->data[rand_next(SIZE)];
  }

  printf("%d\n", sum);

  ds_destroy(numbers);
  return 0;
}
