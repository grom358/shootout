package com.cameronzemek.fasta;

public class Random {
  private final static int IM = 139968;
  private final static int IA = 3877;
  private final static int IC = 29573;
  private int seed = 42;

  public double next() {
    seed = (seed * IA + IC) % IM;
    return ((double)seed) / IM;
  }
}
