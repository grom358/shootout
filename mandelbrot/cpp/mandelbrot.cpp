#include <cstdlib>
#include <iostream>
#include <fstream>
#include <system_error>

int main(int argc, char **argv) {
  if (argc != 3) {
    std::cerr << "Usage: mandelbrot <size> <output.pbm>\n";
    return 1;
  }

  int w, h, bit_num = 0;
  unsigned char byte_acc = 0;
  int iterations = 50;
  double limitSq = 4.0;
  double Zr, Zi, Cr, Ci, Tr, Ti;

  w = h = std::atoi(argv[1]);

  std::ofstream out(argv[2], std::ios::binary);
  if (!out) {
    std::error_code ec(errno, std::generic_category());
    std::cerr << "Error opening file '" << argv[2] << "': " << ec.message() << std::endl;
    return 1;
  }

  out << "P4\n" << w << " " << h << "\n";

  for (int y = 0; y < h; ++y) {
    Ci = (2.0 * y / h - 1.0);
    for (int x = 0; x < w; ++x) {
      Zr = Zi = Tr = Ti = 0.0;
      Cr = (2.0 * x / w - 1.5);

      for (int i = 0; i < iterations && (Tr + Ti <= limitSq); ++i) {
        Zi = 2.0 * Zr * Zi + Ci;
        Zr = Tr - Ti + Cr;
        Tr = Zr * Zr;
        Ti = Zi * Zi;
      }

      byte_acc <<= 1;
      if (Tr + Ti <= limitSq)
        byte_acc |= 0x01;

      ++bit_num;

      if (bit_num == 8) {
        out.put(byte_acc);
        byte_acc = 0;
        bit_num = 0;
      } else if (x == w - 1) {
        byte_acc <<= (8 - w % 8);
        out.put(byte_acc);
        byte_acc = 0;
        bit_num = 0;
      }
    }
  }

  return 0;
}
