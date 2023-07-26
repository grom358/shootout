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

  static void printFrequencies(String data, int k) {
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
      System.out.println(entry.getKey().toUpperCase() + " " +
                         String.format("%.3f", frequency * 100));
    }
    System.out.println();
  }

  static void printSampleCount(String data, String sample) {
    int k = sample.length();
    Map<String, Integer> counts = countNucleotides(data, k);
    System.out.println(counts.getOrDefault(sample.toLowerCase(), 0) + "\t" +
                       sample);
  }

  public static void main(String[] args) throws IOException {
    try (BufferedReader reader =
             new BufferedReader(new InputStreamReader(System.in))) {

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
      printFrequencies(data, 1);
      printFrequencies(data, 2);
      printSampleCount(data, "GGT");
      printSampleCount(data, "GGTA");
      printSampleCount(data, "GGTATT");
      printSampleCount(data, "GGTATTTTAATT");
      printSampleCount(data, "GGTATTTTAATTTATAGT");
    }
  }
}
