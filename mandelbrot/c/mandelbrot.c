#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
  if (argc != 3) {
    fprintf(stderr, "Usage: %s [size] [output-file]\n", argv[0]);
    return 1;
  }

  int w, h, bit_num = 0;
  char byte_acc = 0;
  int iterations = 50;
  double limitSq = 4.0;
  double Zr, Zi, Cr, Ci, Tr, Ti;

  w = h = atoi(argv[1]);

  const char *output_path = argv[2];
  FILE *out = fopen(output_path, "wb");
  if (!out) {
    perror("Failed to open output file");
    return 1;
  }

  fprintf(out, "P4\n%d %d\n", w, h);

  for (double y = 0; y < h; ++y) {
    Ci = (2.0 * y / h - 1.0);
    for (double x = 0; x < w; ++x) {
      Zr = Zi = Tr = Ti = 0.0;
      Cr = (2.0 * x / w - 1.5);

      for (int i = 0; i < iterations && (Tr + Ti <= limitSq); ++i) {
        Zi = 2.0 * Zr * Zi + Ci;
        Zr = Tr - Ti + Cr;
        Tr = Zr * Zr;
        Ti = Zi * Zi;
      }

      byte_acc <<= 1;
      if (Tr + Ti <= limitSq) {
        byte_acc |= 0x01;
      }

      ++bit_num;

      if (bit_num == 8) {
        fputc(byte_acc, out);
        byte_acc = 0;
        bit_num = 0;
      } else if (x == w - 1) {
        byte_acc <<= (8 - w % 8);
        fputc(byte_acc, out);
        byte_acc = 0;
        bit_num = 0;
      }
    }
  }
}
