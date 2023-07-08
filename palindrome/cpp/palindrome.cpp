#include <iostream>
#include <thread>
#include <vector>

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

void calculate_sum(int start, int end, long long &sum) {
  sum = 0;

  for (int x = start; x <= end; x++) {
    if (is_palindrome(x)) {
      sum += x;
    }
  }
}

int main() {
  int start = 100000000;
  int end = 999999999;
  int range = end - start;

  int cores = 4;
  int chunk = range / cores;

  std::vector<std::thread> threads(cores);
  std::vector<long long> results(cores);

  for (int i = 0; i < cores; i++) {
    int t_start = start + (chunk * i);
    int t_end = (i == cores - 1) ? end : t_start + chunk - 1;

    threads[i] =
        std::thread(calculate_sum, t_start, t_end, std::ref(results[i]));
  }

  long long result = 0;

  for (int i = 0; i < cores; i++) {
    threads[i].join();
    result += results[i];
  }

  std::cout << result << std::endl;

  return 0;
}
