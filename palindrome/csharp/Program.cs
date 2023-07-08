namespace palindrome;
class Program {
  static long sum = 0;

  public static void Main(string[] args) {
    int start = 100_000_000;
    int end = 999_999_999;
    int range = end - start;

    int cores = 4;
    int chunk = range / cores;

    Thread[] threads = new Thread[cores];
    for (int i = 0; i < cores; ++i) {
      int threadStart = start + (chunk * i);
      int threadEnd = (i == cores - 1) ? end : (threadStart + chunk - 1);
      threads[i] = new Thread(() => CalculateSum(threadStart, threadEnd));
      threads[i].Start();
    }

    foreach (Thread thread in threads) {
      thread.Join();
    }

    Console.WriteLine(sum);
  }

  public static bool IsPalindrome(int number) {
    int reversedNumber = 0;
    int originalNumber = number;

    int n = number;
    while (n != 0) {
      int digit = n % 10;
      reversedNumber = reversedNumber * 10 + digit;
      n /= 10;
    }

    return originalNumber == reversedNumber;
  }

  public static void CalculateSum(int start, int end) {
    long localSum = 0;
    for (int x = start; x <= end; ++x) {
      if (IsPalindrome(x)) {
        localSum += x;
      }
    }
    Interlocked.Add(ref sum, localSum);
  }
}
