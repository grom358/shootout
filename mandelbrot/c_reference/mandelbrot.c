#include <errno.h>
#include <complex.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
  if (argc != 3) {
    fprintf(stderr, "Usage: %s <size> <output.pbm>\n", argv[0]);
    return 1;
  }

  int w, h, bit_num = 0;
  char byte_acc = 0;
  int i, iter = 50;
  double x, y, limit = 2.0;

  w = h = atoi(argv[1]);

  const char *output_path = argv[2];
  FILE *out = fopen(output_path, "wb");
  if (!out) {
    fprintf(stderr, "Failed to open output file '%s': %s\n", argv[2], strerror(errno));
    return 1;
  }

  fprintf(out, "P4\n%d %d\n", w, h);

  for (y = 0; y < h; ++y) {
    for (x = 0; x < w; ++x) {
      double complex Z = 0.0 + 0.0 * I;
      double complex C = (2.0 * x / w - 1.5) + (2.0 * y / h - 1.0) * I;

      for (i = 0; i < iter; ++i) {
        Z = Z * Z + C;
        if (cabs(Z) > limit) {
          break;
        }
      }

      byte_acc <<= 1;
      if (i == iter) {
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

  return 0;
}
