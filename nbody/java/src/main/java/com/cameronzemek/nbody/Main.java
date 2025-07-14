package com.cameronzemek.nbody;

import java.text.*;

public class Main {
  public static void main(String[] args) {
    if (args.length != 1) {
      System.err.println("Usage: nbody <num_steps>");
      System.exit(1);
    }

    NumberFormat nf = NumberFormat.getInstance();
    nf.setMaximumFractionDigits(9);
    nf.setMinimumFractionDigits(9);
    nf.setGroupingUsed(false);

    int n = Integer.parseInt(args[0]);

    NBodySystem system = new NBodySystem();

    System.out.println(nf.format(system.energy()));
    for (int i = 0; i < n; ++i) {
      system.advance(0.01);
    }
    System.out.println(nf.format(system.energy()));
  }
}
