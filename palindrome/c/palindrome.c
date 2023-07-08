#include <pthread.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct {
  int start;
  int end;
  long long sum;
} ThreadData;

bool is_palindrome(int number) {
  int reversed_number = 0;
  int original_number = number;

  int n = number;
  while (n != 0) {
    int digit = n % 10;
    reversed_number = reversed_number * 10 + digit;
    n /= 10;
  }

  return original_number == reversed_number;
}

void *calculate_sum(void *arg) {
  ThreadData *data = (ThreadData *)arg;
  data->sum = 0;

  for (int x = data->start; x <= data->end; x++) {
    if (is_palindrome(x)) {
      data->sum += x;
    }
  }

  return NULL;
}

int main() {
  int start = 100000000; // Starting number
  int end = 999999999;   // Ending number
  int range = end - start;

  int cores = 4;
  int chunk = range / cores;

  pthread_t threads[cores];
  ThreadData thread_data[cores];

  for (int i = 0; i < cores; i++) {
    thread_data[i].start = start + (chunk * i);
    thread_data[i].end =
        (i == cores - 1) ? end : thread_data[i].start + chunk - 1;

    pthread_create(&threads[i], NULL, calculate_sum, &thread_data[i]);
  }

  long long result = 0;

  for (int i = 0; i < cores; i++) {
    pthread_join(threads[i], NULL);
    result += thread_data[i].sum;
  }

  printf("%lld\n", result);

  return 0;
}
