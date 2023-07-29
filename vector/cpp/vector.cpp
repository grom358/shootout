#include <iostream>
#include <vector>

const int IM = 139968;
const double IMF = static_cast<double>(IM);
const int IA = 3877;
const int IC = 29573;

class Random {
private:
  int seed = 42;

public:
  int next(int max) {
    seed = (seed * IA + IC) % IM;
    return static_cast<int>(max * (seed / IMF));
  }
};

int main() {
  Random rand;
  std::vector<int> numbers;
  numbers.reserve(16);
  const int MAX = 100;
  const int SIZE = 200000000;

  for (int i = 0; i < SIZE; i++) {
    numbers.push_back(rand.next(MAX));
  }

  int sum = 0;
  for (int i = 0; i < 1000; i++) {
    sum += numbers[rand.next(SIZE) % SIZE];
  }

  std::cout << sum << std::endl;
  return 0;
}
