package com.cameronzemek.knucleotide;

import java.io.*;
import java.util.*;

public class Main {
  static Map<String, Integer> countNucleotides(String data, int k) {
    Map<String, Integer> counts = new HashMap<>();
    int endIndex = data.length() - k;
    for (int i = 0; i <= endIndex; i++) {
      String fragment = data.substring(i, i + k);
      counts.merge(fragment, 1, Integer::sum);
    }
    return counts;
  }

  static void printFrequencies(PrintWriter out, String data, int k) {
    Map<String, Integer> counts = countNucleotides(data, k);
    double total = 0;
    for (int value : counts.values()) {
      total += value;
    }
    List<Map.Entry<String, Integer>> entryList =
        new ArrayList<>(counts.entrySet());
    entryList.sort(
        (entry1, entry2) -> entry2.getValue().compareTo(entry1.getValue()));
    for (Map.Entry<String, Integer> entry : entryList) {
      double frequency = entry.getValue() / total;
      out.println(entry.getKey().toUpperCase() + " " +
                         String.format("%.3f", frequency * 100));
    }
    out.println();
  }

  static void printSampleCount(PrintWriter out, String data, String sample) {
    int k = sample.length();
    Map<String, Integer> counts = countNucleotides(data, k);
    out.println(counts.getOrDefault(sample.toLowerCase(), 0) + "\t" +
                       sample);
  }

  public static void main(String[] args) throws IOException {
    if (args.length != 2) {
      System.err.println("Usage: knucleotide <input.txt> <output.txt>");
      System.exit(1);
    }

    String inputFile = args[0];
    String outputFile = args[1];

    try (BufferedReader reader =
             new BufferedReader(new FileReader(inputFile))) {

      String line;
      while ((line = reader.readLine()) != null) {
        if (line.startsWith(">THREE")) {
          break;
        }
      }

      // Extract DNA sequence THREE.
      StringBuilder sb = new StringBuilder();
      while ((line = reader.readLine()) != null) {
        sb.append(line);
      }

      String data = sb.toString();
      try (PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(outputFile)))) {
        printFrequencies(out, data, 1);
        printFrequencies(out, data, 2);
        printSampleCount(out, data, "GGT");
        printSampleCount(out, data, "GGTA");
        printSampleCount(out, data, "GGTATT");
        printSampleCount(out, data, "GGTATTTTAATT");
        printSampleCount(out, data, "GGTATTTTAATTTATAGT");
      }
    }
  }
}
