package com.cameronzemek.palindrome;

import java.util.concurrent.atomic.AtomicLong;

public class Main {
  public static void main(String[] args) throws Exception {
    final int start = 100_000_000;
    final int end = 999_999_999;
    final int range = end - start;

    final int cores = 4;
    final int chunk = range / cores;
    AtomicLong sum = new AtomicLong(0);

    Thread[] handles = new Thread[cores];
    for (int i = 0; i < cores; ++i) {
      final int threadStart = start + (chunk * i);
      final int threadEnd = (i == cores - 1) ? end : (threadStart + chunk - 1);
      Thread t = new Thread(() -> calculateSum(threadStart, threadEnd, sum));
      t.start();
      handles[i] = t;
    }

    for (Thread handle : handles) {
      handle.join();
    }
    System.out.println(sum.get());
  }

  public static boolean isPalindrome(int number) {
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

  public static void calculateSum(int start, int end, AtomicLong sum) {
    long localSum = 0;
    for (int x = start; x <= end; ++x) {
      if (isPalindrome(x)) {
        localSum += x;
      }
    }
    sum.addAndGet(localSum);
  }
}
