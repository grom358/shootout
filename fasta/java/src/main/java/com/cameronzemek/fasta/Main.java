package com.cameronzemek.fasta;

import java.io.PrintStream;

public class Main {
  public static void main(String[] args) throws Exception {
    if (args.length != 2) {
      System.err.println("Usage: fasta <size> <output.txt>");
      System.exit(1);
    }

    int n = Integer.parseInt(args[0]);

    String outputFile = args[1];
    BufferedPrintStream out = new BufferedPrintStream(new PrintStream(outputFile));

    Fasta f = new Fasta(out);

    String alu = "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTG"
                 + "GGAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGA"
                 + "GACCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAA"
                 + "AATACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAAT"
                 + "CCCAGCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAAC"
                 + "CCGGGAGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTG"
                 + "CACTCCAGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA";
    f.repeatFasta(">ONE Homo sapiens alu", alu, 2 * n);

    AminoAcid[] iub = {new AminoAcid(0.27, 'a'), new AminoAcid(0.12, 'c'),
                       new AminoAcid(0.12, 'g'), new AminoAcid(0.27, 't'),
                       new AminoAcid(0.02, 'B'), new AminoAcid(0.02, 'D'),
                       new AminoAcid(0.02, 'H'), new AminoAcid(0.02, 'K'),
                       new AminoAcid(0.02, 'M'), new AminoAcid(0.02, 'N'),
                       new AminoAcid(0.02, 'R'), new AminoAcid(0.02, 'S'),
                       new AminoAcid(0.02, 'V'), new AminoAcid(0.02, 'W'),
                       new AminoAcid(0.02, 'Y')};
    f.randomFasta(">TWO IUB ambiguity codes", iub, 3 * n);

    AminoAcid[] homosapiens = {new AminoAcid(0.3029549426680, 'a'),
                               new AminoAcid(0.1979883004921, 'c'),
                               new AminoAcid(0.1975473066391, 'g'),
                               new AminoAcid(0.3015094502008, 't')};
    f.randomFasta(">THREE Homo sapiens frequency", homosapiens, 5 * n);

    out.flush();
  }
}
