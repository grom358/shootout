#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MIN(a, b) (((a) < (b)) ? (a) : (b))

#define IM 139968
#define IA 3877
#define IC 29573
int seed = 42;

double random_num() {
  seed = (seed * IA + IC) % IM;
  return ((double)seed) / IM;
}

#define WIDTH 60 // Fold lines after WIDTH bytes

typedef struct {
  double p;
  char c;
} AminoAcid;

void repeat_fasta(const char *header, const char *s, int count) {
  printf("%s", header);
  size_t pos = 0;
  int s_len = (int) strlen(s);
  char *ss = malloc(s_len * 2);
  memcpy(ss, s, s_len);
  memcpy(ss + s_len, s, s_len);

  while (count > 0) {
    int length = MIN(WIDTH, count);
    fwrite(ss + pos, 1, length, stdout);
    fputc('\n', stdout);
    pos += length;
    if (pos > s_len) {
      pos -= s_len;
    }
    count -= length;
  }

  free(ss);
}

void accumulate_probabilities(AminoAcid *genelist, int size) {
  double cp = 0.0;
  for (int i = 0; i < size; i++) {
    cp += genelist[i].p;
    genelist[i].p = cp;
  }
}

void random_fasta(const char *header, AminoAcid *genelist, int size,
                  int count) {
  printf("%s", header);
  accumulate_probabilities(genelist, size);
  char buf[WIDTH + 2];
  while (count > 0) {
    int length = MIN(WIDTH, count);
    for (int pos = 0; pos < length; pos++) {
      double r = random_num();
      for (int i = 0; i < size; i++) {
        if (genelist[i].p >= r) {
          buf[pos] = genelist[i].c;
          break;
        }
      }
    }
    buf[length] = '\n';
    fwrite(buf, 1, length + 1, stdout);
    count -= length;
  }
}

int main(int argc, char *argv[]) {
  if (argc != 2) {
    fprintf(stderr, "Usage: fasta [size]\n");
    exit(1);
  }

  int n = atoi(argv[1]);

  const char alu[] = "GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTG"
                     "GGAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGA"
                     "GACCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAA"
                     "AATACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAAT"
                     "CCCAGCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAAC"
                     "CCGGGAGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTG"
                     "CACTCCAGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA";
  repeat_fasta(">ONE Homo sapiens alu\n", alu, 2 * n);

  AminoAcid iub[] = {{0.27, 'a'}, {0.12, 'c'}, {0.12, 'g'}, {0.27, 't'},
                     {0.02, 'B'}, {0.02, 'D'}, {0.02, 'H'}, {0.02, 'K'},
                     {0.02, 'M'}, {0.02, 'N'}, {0.02, 'R'}, {0.02, 'S'},
                     {0.02, 'V'}, {0.02, 'W'}, {0.02, 'Y'}};
  int iub_size = sizeof(iub) / sizeof(AminoAcid);
  random_fasta(">TWO IUB ambiguity codes\n", iub, iub_size, 3 * n);

  AminoAcid homosapiens[] = {{0.3029549426680, 'a'},
                             {0.1979883004921, 'c'},
                             {0.1975473066391, 'g'},
                             {0.3015094502008, 't'}};
  int homosapiens_size = sizeof(homosapiens) / sizeof(AminoAcid);
  random_fasta(">THREE Homo sapiens frequency\n", homosapiens, homosapiens_size,
               5 * n);

  return 0;
}
