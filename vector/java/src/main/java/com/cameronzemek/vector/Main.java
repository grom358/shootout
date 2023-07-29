package com.cameronzemek.vector;

import java.util.ArrayList;

public class Main {
  static class Random {
    private final static int IM = 139968;
    private final static double IMF = IM;
    private final static int IA = 3877;
    private final static int IC = 29573;
    private int seed = 42;

    public int next(int max) {
      seed = (seed * IA + IC) % IM;
      return (int)(max * (seed / IMF));
    }
  }

  public static void main(String[] args) {
    Random rand = new Random();
    ArrayList<Integer> numbers = new ArrayList<>(16);
    final int MAX = 100;
    final int SIZE = 200_000_000;
    for (int i = 0; i < SIZE; i++) {
      numbers.add(rand.next(MAX));
    }
    long sum = 0;
    for (int i = 0; i < 1_000; i++) {
      sum += numbers.get(rand.next(SIZE));
    }
    System.out.println(sum);
  }
}
