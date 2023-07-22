package com.cameronzemek.fasta;

class Fasta {
  final int WIDTH = 60; // Fold lines after WIDTH bytes
  final Random rand = new Random();

  BufferedPrintStream out;

  Fasta(BufferedPrintStream out) { this.out = out; }

  void repeatFasta(String header, String s, int count) {
    out.println(header);
    int pos = 0;
    int sLen = s.length();
    String d = s + s;
    while (count > 0) {
      int length = WIDTH < count ? WIDTH : count;
      out.println(d.substring(pos, pos + length));
      pos += length;
      if (pos > sLen) {
        pos -= sLen;
      }
      count -= length;
    }
  }

  void accumulateProbabilities(AminoAcid[] genelist) {
    for (int i = 1; i < genelist.length; i++) {
      genelist[i].p += genelist[i - 1].p;
    }
  }

  void randomFasta(String header, AminoAcid[] genelist, int count) {
    out.println(header);
    accumulateProbabilities(genelist);
    StringBuilder sb = new StringBuilder(WIDTH + 1);
    while (count > 0) {
      int length = WIDTH < count ? WIDTH : count;
      for (int pos = 0; pos < length; pos++) {
        double r = rand.next();
        for (AminoAcid v : genelist) {
          if (v.p >= r) {
            sb.append(v.c);
            break;
          }
        }
      }
      out.println(sb.toString());
      sb.setLength(0);
      count -= length;
    }
  }
}
