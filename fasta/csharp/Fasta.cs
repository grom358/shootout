using System.Text;

namespace Fasta;

struct AminoAcid {
  public double p;
  public char c;

  public AminoAcid(double p, char c) {
    this.p = p;
    this.c = c;
  }
}

class Random {
  int seed = 42;
  const int IM = 139968;
  const int IA = 3877;
  const int IC = 29573;

  public double Next() {
    seed = (seed * IA + IC) % IM;
    return ((double)seed) / IM;
  }
}

class Fasta {
  const int WIDTH = 60;
  Random rand = new Random();

  void AccumulateProbabilities(AminoAcid[] genelist) {
    double cp = 0.0;
    for (int i = 0; i < genelist.Length; i++) {
      cp += genelist[i].p;
      genelist[i].p = cp;
    }
  }

  public void RandomFasta(string header, AminoAcid[] genelist, int count) {
    Console.WriteLine(header);
    AccumulateProbabilities(genelist);
    StringBuilder sb = new StringBuilder(WIDTH);
    while (count > 0) {
      int length = Math.Min(WIDTH, count);
      for (int pos = 0; pos < length; pos++) {
        double r = rand.Next();
        foreach (AminoAcid amino in genelist) {
          if (amino.p >= r) {
            sb.Append(amino.c);
            break;
          }
        }
      }
      Console.WriteLine(sb.ToString());
      sb.Clear();
      count -= length;
    }
  }

  public void RepeatFasta(string header, string s, int count) {
    Console.WriteLine(header);
    int pos = 0;
    int sLen = s.Length;
    string ss = s + s;

    while (count > 0) {
      int length = Math.Min(WIDTH, count);
      Console.WriteLine(ss.Substring(pos, length));
      pos += length;
      if (pos > sLen) {
        pos -= sLen;
      }
      count -= length;
    }
  }
}
