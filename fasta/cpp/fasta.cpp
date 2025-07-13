#include <fstream>
#include <iostream>
#include <string>
#include <vector>

int min(int a, int b) { return (a < b) ? a : b; }

const int IM = 139968;
const int IA = 3877;
const int IC = 29573;
int seed = 42;

double random_num() {
  seed = (seed * IA + IC) % IM;
  return static_cast<double>(seed) / IM;
}

#define WIDTH 60 // Fold lines after WIDTH bytes

struct AminoAcid {
  double p;
  char c;
};

void repeat_fasta(std::ostream &out, const std::string &header, const std::string &s, int count) {
  out << header;
  int pos = 0;
  int s_len = s.length();
  std::string ss = s + s;

  while (count > 0) {
    int length = min(WIDTH, count);
    out << ss.substr(pos, length) << '\n';
    pos += length;
    if (pos > s_len) {
      pos -= s_len;
    }
    count -= length;
  }
}

void accumulate_probabilities(std::vector<AminoAcid> &genelist) {
  double cp = 0.0;
  for (auto &amino : genelist) {
    cp += amino.p;
    amino.p = cp;
  }
}

void random_fasta(std::ostream &out, const std::string &header, std::vector<AminoAcid> &genelist,
                  int count) {
  out << header;
  accumulate_probabilities(genelist);
  std::string buf;

  while (count > 0) {
    int length = min(WIDTH, count);
    for (int pos = 0; pos < length; pos++) {
      double r = random_num();
      for (const auto &amino : genelist) {
        if (amino.p >= r) {
          buf += amino.c;
          break;
        }
      }
    }
    buf += '\n';
    out << buf;
    buf.clear();
    count -= length;
  }
}

int main(int argc, char *argv[]) {
  if (argc != 3) {
    std::cerr << "Usage: fasta [size] [output-file]\n";
    exit(1);
  }

  int n = std::atoi(argv[1]);

  std::ofstream out(argv[2]);
  if (!out) {
    std::cerr << "Error opening file: " << argv[2] << std::endl;
    return 1;
  }

  const std::string alu = "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTG"
                          "GGAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGA"
                          "GACCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAA"
                          "AATACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAAT"
                          "CCCAGCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAAC"
                          "CCGGGAGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTG"
                          "CACTCCAGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA";
  repeat_fasta(out, ">ONE Homo sapiens alu\n", alu, 2 * n);

  std::vector<AminoAcid> iub = {
      {0.27, 'a'}, {0.12, 'c'}, {0.12, 'g'}, {0.27, 't'}, {0.02, 'B'},
      {0.02, 'D'}, {0.02, 'H'}, {0.02, 'K'}, {0.02, 'M'}, {0.02, 'N'},
      {0.02, 'R'}, {0.02, 'S'}, {0.02, 'V'}, {0.02, 'W'}, {0.02, 'Y'}};
  random_fasta(out, ">TWO IUB ambiguity codes\n", iub, 3 * n);

  std::vector<AminoAcid> homosapiens = {{0.3029549426680, 'a'},
                                        {0.1979883004921, 'c'},
                                        {0.1975473066391, 'g'},
                                        {0.3015094502008, 't'}};
  random_fasta(out, ">THREE Homo sapiens frequency\n", homosapiens, 5 * n);

  return 0;
}
